source "https://rubygems.org"

# Real pre-publish build (board, 2026-11-02): the same plugins and versions as GitHub Pages' own build.
# Workspaces only have the system Ruby 2.6, so the resolver picks the newest github-pages release that
# supports it. Gemfile.lock is committed: that file is the exact pin everyone builds with.
# Install and build with tools/build.sh (see HANDOFF.md "Pre-publish build").
# No `ruby` directive on purpose: if GitHub Pages' builder ever honoured it, its newer Ruby would fail
# the live build. Bundler already resolves for the Ruby that runs it.

gem "github-pages", group: :jekyll_plugins
gem "nokogiri", "~> 1.13.10"   # 1.14+ needs Ruby 2.7
gem "ffi", "~> 1.16.3"         # 1.17 precompiled gems need Ruby 3.0
gem "webrick", "~> 1.7"        # only for `jekyll serve`; builds don't need it
