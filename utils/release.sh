#!/bin/sh
#
# Generate a zippable addon directory from a Git checkout.
#

# Project name.
project="Ovale Spell Priority"
# Path to root of Git checkout.
topdir=..
# Path to directory containing the generated addon.
releasedir="$topdir/release"

# POSIX tools.
cat=cat
cmp=cmp
cp=cp
find=find
mkdir=mkdir
rm=rm
sed=sed

# Non-POSIX tools.
git=git
svn=svn
zip=zip

# pkzip wrapper for 7z.
sevenzip=7z
zip() {
	archive="$1"; shift
	$sevenzip a -tzip $archive "$@"
}

usage() {
	echo "Usage: release.sh [-eoz] [-r dir]" >&2
	echo "  -e        Skip checkout of external repositories." >&2
	echo "  -o        Keep existing package directory; just overwrite contents." >&2
	echo "  -r dir    Set directory containing the package directory." >&2
	echo "  -z        Skip zipfile creation." >&2
}

# Process command-line options
while getopts ":eor:z" opt; do
	case $opt in
	e)
		# Skip checkout of external repositories.
		skip_externals=true
		;;
	o)
		# Skip deleting any previous package directory.
		skip_delete_pkgdir=true
		;;
	r)
		# Set the release directory to a non-default value.
		releasedir="$OPTARG"
		;;
	z)
		# Skip generating the zipfile.
		skip_zipfile=true
		;;
	:)
		echo "Option \`\`-$OPTARG'' requires an argument." >&2
		usage
		exit 1
		;;
	\?)
		echo "Unknown option \`\`-$OPTARG''." >&2
		usage
		exit 2
		;;
	esac
done

# $releasedir must be an absolute path or relative to $topdir.
case $releasedir in
/*)			;;
$topdir/*)	;;
*)
	echo "The release directory \`\`$releasedir'' must be an absolute path or relative to \`\`$topdir''." >&2
	exit 3
	;;
esac

# Get the tag for the HEAD.
tag=`$git describe HEAD --abbrev=0`
# Find the previous release tag.
rtag=`$git describe HEAD~1 --abbrev=0`
while true; do
	case $rtag in
	[0-9].[0-9]) break ;;
	[0-9].[0-9].[0-9]) break ;;
	[0-9].[0-9].[0-9][0-9]) break ;;
	[0-9].[0-9].[0-9][0-9][0-9]) break ;;
	[0-9].[0-9][0-9]) break ;;
	[0-9].[0-9][0-9].[0-9]) break ;;
	[0-9].[0-9][0-9].[0-9][0-9]) break ;;
	[0-9].[0-9][0-9].[0-9][0-9][0-9]) break ;;
	esac
	rtag=`git describe $rtag~1 --abbrev=0`
done
# If the current and previous tags match, then the HEAD is not tagged.
if [ "$tag" = "$rtag" ]; then
	tag=
else
	echo "Current tag: $tag"
fi
echo "Previous release tag: $rtag"

# Version number.
version="$tag"
if [ -z "$version" ]; then
	version=`$git describe HEAD`
fi

# Simple .pkgmeta processor.
ignore=
while read line; do
	case ${line} in
	package-as:*)
		phase=${line%%:*}
		package=${line#*: }
		pkgdir="$releasedir/$package"
		if [ -d "$pkgdir" -a -z "$skip_delete_pkgdir" ]; then
			echo "Removing previous package directory: $pkgdir"
			$rm -fr "$pkgdir"
		fi
		$mkdir -p "$pkgdir"
		;;
	externals:*)
		phase=${line%%:*}
		;;
	ignore:*)
		phase=${line%%:*}
		;;
	manual-changelog:*)
		phase=${line%%:*}
		changelog=${line#*: }
		;;
	filename:*)
		if [ "$phase" = "manual-changelog" ]; then
			changelog=${line#*: }
		fi
		;;
	*git*|*svn*)
		if [ "$phase" = "externals" -a -z "$skip_externals" ]; then
			dir=${line%%:*}
			uri=${line#*: }
			$mkdir -p "$pkgdir/$dir"
			case $uri in
			git:*)
				echo "Getting checkout for $uri"
				$git clone $uri "$pkgdir/$dir"
				;;
			svn:*)
				echo "Getting checkout for $uri"
				$svn checkout $uri "$pkgdir/$dir"
				;;
			esac
		fi
		;;
	*"- "*)
		if [ "$phase" = "ignore" ]; then
			pattern=${line#*- }
			if [ -d "../$pattern" ]; then
				pattern="$pattern/*"
			fi
			if [ -z "$ignore" ]; then
				ignore="$pattern"
			else
				ignore="$ignore:$pattern"
			fi
		fi
		;;
	esac
done < ../.pkgmeta
$find "$pkgdir" -name .git -print -o -name .svn -print | while read dir; do
	$rm -fr "$dir"
done

# Copy files from working directory into the package directory.
echo "Copying files into \`\`$pkgdir''..."
$find "$topdir" -name .git -prune -o -print | while read file; do
	file=${file#$topdir/}
	if [ "$file" != "$topdir" -a -f "$topdir/$file" ]; then
		# Check if the file should be ignored.
		ignored=
		if [ -z "$ignored" ]; then
			case $file in
			# Ignore files that start with a dot.
			.*)
				echo "Ignoring: $file"
				ignored=true
				;;
			# Ignore files within the release directory.
			"$releasedir"/*)
				echo "Ignoring: $file"
				ignored=true
				;;
			esac
		fi
		# Ignore files matching patterns set via .pkgmeta "ignore".
		if [ -z "$ignored" ]; then
			list="$ignore:"
			while [ -n "$list" ]; do
				pattern=${list%%:*}
				list=${list#*:}
				case $file in
				$pattern)
					echo "Ignoring: $file"
					ignored=true
					break
					;;
				esac
			done
		fi
		# Copy any unignored files into $pkgdir.
		if [ -z "$ignored" ]; then
			dir=${file%/*}
			if [ "$dir" != "$file" ]; then
				$mkdir -p "$pkgdir/$dir"
			fi
			# Check if the file matches a pattern for keyword replacement.
			keyword="*.lua:*.md:*.toc:*.xml"
			list="$keyword:"
			replaced=
			while [ -n "$list" ]; do
				pattern=${list%%:*}
				list=${list#*:}
				case $file in
				$pattern)
					replaced=true
					break
					;;
				esac
			done
			if [ -n "$replaced" -a -n "$version" ]; then
				$sed -b "s/@project-version@/$version/g" "$topdir/$file" > "$pkgdir/$file"
				if $cmp -s "$topdir/$file" "$pkgdir/$file"; then
					echo "Copied: $file"
				else
					echo "Replaced repository keywords: $file"
				fi
			else
				$cp "$topdir/$file" "$pkgdir/$dir"
				echo "Copied: $file"
			fi
		fi
	fi
done

# Create changelog of commits since the previous release tag.
if [ -z "$changelog" ]; then
	changelog="CHANGELOG.txt"
fi
echo "Generating changelog of commits since $rtag into $changelog."
$cat > "$pkgdir/$changelog" << EOF
$project $version

Changes from version $rtag:

EOF
$git log $rtag..HEAD --pretty=format:"- %B" >> "$pkgdir/$changelog"
$sed -i "s/$/\r/" "$pkgdir/$changelog"

# Creating the final zipfile for the addon using 7z.
if [ -z "$skip_zipfile" ]; then
	archive="$releasedir/$package-$version.zip"
	if [ -f "$archive" ]; then
		echo "Removing previous archive: $archive"
		$rm -f "$archive"
	fi
	$zip "$archive" "$pkgdir"
fi
