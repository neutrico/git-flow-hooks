#!/usr/bin/env bash

#set -ex

VERSION_FILE=$(__get_version_file)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)

if [ ! -z "$VERSION_PREFIX" ]; then
    VERSION=${VERSION#$VERSION_PREFIX}
fi

echo -n "$VERSION" > $VERSION_FILE && \
    git add $VERSION_FILE && \
    git commit -m "Bumped version to $VERSION"


if [ -f composer.json ]; then

    TEMPFILE=$(tempfile)

    echo "POST Flow release finish - omposer.json exists. Version bump to $VERSION in $ROOTDIR."

    jq "del(.version) + { \"version\": \"$VERSION\" }" composer.json > $TEMPFILE && mv -f $TEMPFILE composer.json

    TYPE=$(jq -r '.type' composer.json)

    if [ $TYPE == "wordpress-theme" ]; then
	echo "POST Flow release finish - WordPress Theme version bump: $VERSION"

	# Ensure we got style.css to bump

	if [ -f $ROOTDIR/assets/styles/style.scss ]; then

	    sed -i 's/^Version:.*/Version: '$VERSION'/' $ROOTDIR/assets/styles/style.scss

	    sass --sourcemap=none \
		 --load-path="vendor/bower_components/bootstrap-sass/assets/stylesheets" \
		 --style=compressed \
		 'assets/styles/style.scss' 'style.css'
	fi

	if [ -f $ROOTDIR/style.css ]; then
	    sed -i 's/^Version:.*/Version: '$VERSION'/' $ROOTDIR/style.css
	fi

    fi

    if [ $TYPE == "wordpress-plugin" ]; then

	echo "POST Flow release finish - WordPress Plugin version bump to: $VERSION"

	find $ROOTDIR -maxdepth 1 -type f -name '*.php' -exec \
	     sed -i 's/^Version:.*/Version: '$VERSION'/g' {} +

	find $ROOTDIR -maxdepth 1 -type f -name '*.php' -exec \
	     sed -i 's/\* Version:.*/\* Version: '$VERSION'/g' {} +

    fi

fi

if [ -f bower.json ]; then

    TEMPFILE=$(tempfile)

    echo "POST Flow release finish - Bower version bump to $VERSION."
    jq "del(.version) + { \"version\": \"$VERSION\" }" bower.json > $TEMPFILE && mv -f $TEMPFILE bower.json
fi

if [ -f package.json ]; then

    TEMPFILE=$(tempfile)

    echo "POST Flow release finish - Package.json version bump to $VERSION."
    jq "del(.version) + { \"version\": \"$VERSION\" }" package.json > $TEMPFILE && mv -f $TEMPFILE package.json
fi

if [ $? -ne 0 ]; then
    __print_fail "Unable to write version to $VERSION_FILE."
    return 1
else
    return 0
fi
