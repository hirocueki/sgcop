#!/bin/bash

if [ -n "${GITHUB_ACCESS_TOKEN}" ]; then
  export GITHUB_TOKEN="${GITHUB_ACCESS_TOKEN}"
else
  echo 'GITHUB_ACCESS_TOKEN env var required.'
  exit 1
fi

# gem prepare
gem install --no-document bundler_diffgems git_httpsable-push pull_request-create

# git prepare
# TODO: Allow to customize user
git config user.name sg-bot
git config user.email sg-bot@sonicgarden.jp
HEAD_DATE=$(date +%Y%m%dT%H%M%SZ)
HEAD="bundle/update-${HEAD_DATE}"

# checkout
git checkout -b "${HEAD}" origin/master

# bundle update
bundle lock --update
BODY=$(bundle diffgems -f md_table)

git add Gemfile.lock
git commit -m "Bundle update ${HEAD_DATE}"

# git push
git httpsable-push origin "${HEAD}"

# pull request
pull-request-create create --title "Bundle update by sgcop ${HEAD_DATE}" --body "${BODY}"

exit 0