#!/usr/bin/env bash

VERSION_FILE=$(__get_version_file)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)

if [ ! -z "$VERSION_PREFIX" ]; then
    VERSION=${VERSION#$VERSION_PREFIX}
fi

echo -n "$VERSION" > $VERSION_FILE && \
    git add $VERSION_FILE && \
    git commit -m "Bumped version to $VERSION"


if [ -f composer.json ]; then

    composer update

    TEMPFILE=$(tempfile)

    echo "Composer.json exists. Version bump to $VERSION."
    jq "del(.version) + { \"version\": \"$VERSION\" }" composer.json > $TEMPFILE && mv -f $TEMPFILE composer.json

    TYPE=$(jq -r '.type' composer.json)

    if [ $TYPE == "wordpress-theme" ]; then
	echo "WordPress Theme version bump: $VERSION"

	(
	    cd assets/styles
	    if [ -f style.scss ]; then
		echo "STYLE FOUND"
		sass --sourcemap=none \
		     --load-path="../../vendor/twbs/bootstrap-sass/assets/stylesheets" \
		     --style=compressed \
		     --update '../../'
	    fi
	)

	sed -i 's/^Version:.*/Version: '$VERSION'/' $ROOTDIR/style.css
    fi

    if [ $TYPE == "wordpress-plugin" ]; then
	echo "WordPress Plugin version bump: $VERSION"

	find $ROOTDIR -maxdepth 1 -type f -name '*.php' -exec \
	     sed -i 's/^Version:.*/Version: '$VERSION'/g' {} +

    fi

fi

if [ -f bower.json ]; then

    TEMPFILE=$(tempfile)

    echo "Bower version bump to $VERSION."
    jq "del(.version) + { \"version\": \"$VERSION\" }" bower.json > $TEMPFILE && mv -f $TEMPFILE bower.json
fi

if [ -f package.json ]; then

    TEMPFILE=$(tempfile)

    echo "Package.json version bump to $VERSION."
    jq "del(.version) + { \"version\": \"$VERSION\" }" package.json > $TEMPFILE && mv -f $TEMPFILE package.json
fi

if [ $? -ne 0 ]; then
    __print_fail "Unable to write version to $VERSION_FILE."
    return 1
else
    return 0
fi
