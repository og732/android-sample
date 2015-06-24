#!/bin/bash
#
# github-release.sh
#
#
#

#
# Settings
#

export LANG=ja_JP.UTF-8

VERSION=`cat app/build.gradle | grep versionName | awk '{print $2}' | sed -e 's/"//g'`
OWNER=$CIRCLE_PROJECT_USERNAME
REPO=$CIRCLE_PROJECT_REPONAME
RELEASE_NOTE=RELEASE_NOTE/${VERSION}-note.md
RELEASE_NOTE_TXT="$VERSION release"
OUTPUT_DIR=app/build/outputs/
ARCHIVE=assets.zip
# GitHub TokenはCircleCIの環境変数に設定
#GITHUB_TOKEN=

if [ -f $RELEASE_NOTE ]; then
    RELEASE_NOTE_TXT=`cat $RELEASE_NOTE | awk -F\n -v ORS="\\\\\\n" '{print}' | sed 's|\\\\n$||'`
fi

INPUT="
{
    \"tag_name\": \"${VERSION}\",
    \"target_commitish\": \"master\",
    \"body\": \"${RELEASE_NOTE_TXT}\",
    \"draft\": false,
    \"prerelease\": false
}"


#
# function
#

function create_release() {
    echo "run create release"
    RESULT=$(curl --fail -X POST https://api.github.com/repos/${OWNER}/${REPO}/releases \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "${INPUT}")

    RELEASE_ID=`echo $RESULT | jq ".id"`
}

function upload_assets() {
    echo "run upload release"
    curl --fail -X POST https://uploads.github.com/repos/${OWNER}/${REPO}/releases/${RELEASE_ID}/assets?name=${ARCHIVE_NAME} \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: ${CONTENT_TYPE}" \
        --data-binary @"${ARCHIVE}"
}

#
# Main
#

zip -r assets.zip $OUTPUT_DIR

ARCHIVE_NAME=$(basename ${ARCHIVE})
CONTENT_TYPE=$(file --mime-type -b ${ARCHIVE})

create_release
upload_assets
