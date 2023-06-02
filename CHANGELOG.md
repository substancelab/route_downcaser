# Changelog

## Unreleased

* Added support for URLs with non-ASCII characters in them. In other words, your application shouldn't get stuck in a an infinite redirect loop when a request contains non-ASCII characters that can be downcased.

* Added Ruby 3.0 to the test matrix.

* Added Rails 6.1.x and 7.0.x to the build matrix.

* Dropped support for Rails 4. Going forward we're targetting Rails 5.x (and 6.x). Rails 5 deprecates a few configuration options that we need access to. If you still need support for Rails 4.x, version 1.2.2 of route_downcaser should work just fine.

* Dropped support for Rails versions older than 5.2 (ie 5.0.x, 5.1.x). They are outside Rails official maintenance policy.

* Dropped support for Ruby versions older than 2.5 (ie 2.2, 2.3, 2.4). They are EOL and should not be used in production.

## 1.2.3

* Sinatra users no longer need to `require "active_support"` manually to prevent `NoMethodError`s. Thanks, {Blake}[https://github.com/blakebuthod].

## 1.2.2

* Fixed bug where redirecting multibyte URLs would result in a `Rack::Lint::LintError` (Issue #29).

* Don't lose parts of the querystring when it contains multiple questionmarks. Thanks, {rmeritz}[https://github.com/rmeritz].

## 1.2.1

Support for Rails 5.1, we now support most recently released versions of Rails 4.2, 5.0, and 5.1. Thanks to {pepawel}[https://github.com/pepawel].

No more deprecation warnings about passing strings or symbols to the middleware builder. Thanks, {flou}[https://github.com/flou]!

## 1.2.0

Support for multibyte characters - dependency on ActiveSupport version 3.2 or later

## 1.1.5

Configuration now namespaced to avoid name clashing with other modules. Thanks goes to {tgk}[https://github.com/tgk] for this

## 1.1.4

Better solution to the incompatibility issue with Warden. Thank you to {l3akage}[https://github.com/l3akage]

## 1.1.3

Fixes issue #14. If Devise/Warden is used in the Rails app, RouteDowncaser::DowncaseRouteMiddleware needs to be inserted before Warden::Manager in the middleware list.

## 1.1.2

POST requests must never result in a redirect, even if the config.redirect is true

More robust test-cases have been added

## 1.1.1

Fixed {issue #17}[https://github.com/carstengehling/route_downcaser/issues/17]. Thanks go to {TkiTDO}[https://github.com/TikiTDO]

## 1.1.0

Refactored main code and tests for much better structure

## 1.0.1

Refactored parts of the code to work with Rails 4.2.0

New config for ignoring/excluding paths

## 0.2.2

Redirection is now possible as a configurable option. Thanks goes to {Mike Ackerman}[https://github.com/mackermedia]

## 0.2.1

The gem has now been tested to work with Rails 4.0 (it mostly involved changes in the test dummy-app because of deprecations between Rails 3.2 and 4.0)

## 0.2.0

Asset urls are now ignored - important since filesystems may be case sensitive. Thanks goes to {Casey Pugh}[https://github.com/caseypugh]

## 0.1.2

Removed silly dependencies (sqlite3, etc.)

## 0.1.1

Added documentation README

## 0.1.0

First version of gem
