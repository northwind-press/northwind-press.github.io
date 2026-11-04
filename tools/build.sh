#!/bin/sh
# Real pre-publish build (HANDOFF.md "Pre-publish build"). Run from anywhere in the repo:
#   tools/build.sh            build the site exactly as GitHub Pages would, then run the post checks
#   tools/build.sh --install  first time (or after Gemfile.lock changes): install gems into vendor/bundle
# Gems go to vendor/bundle and bundler's own state to .bundle-home, both inside the workspace,
# because workspaces can't write to /Library or the home directory. Output goes to .render/_site
# (gitignored). Exit code is non-zero if the build or any check fails: don't merge then.
set -eu
cd "$(git rev-parse --show-toplevel)"
export BUNDLE_USER_HOME="$PWD/.bundle-home"
export BUNDLE_PATH="vendor/bundle"
export BUNDLE_WITHOUT=""
export JEKYLL_ENV=production

if [ "${1:-}" = "--install" ]; then
  bundle config set --local path vendor/bundle
  bundle install --jobs 4
fi

echo "== jekyll build"
rm -rf .render/_site
bundle exec jekyll build --strict_front_matter --trace -d .render/_site

echo "== post checks"
ruby tools/check-all-posts.rb HEAD

echo "== output sanity"
for f in index.html ai/index.html software/index.html security/index.html infra/index.html curiosities/index.html \
         feeds/ai.xml feed.xml about/index.html corrections/index.html; do
  [ -s ".render/_site/$f" ] || { echo "MISSING or empty: $f"; exit 1; }
done
if grep -rl --include=*.html -e '{%' -e '{{' .render/_site >/dev/null; then
  echo "Unrendered Liquid found in:"; grep -rl --include=*.html -e '{%' -e '{{' .render/_site | head; exit 1
fi
echo "BUILD OK: $(find .render/_site -name '*.html' | wc -l | tr -d ' ') HTML pages in .render/_site"
