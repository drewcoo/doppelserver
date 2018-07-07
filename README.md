# Doppelserver

[![TravisCI](https://api.travis-ci.org/drewcoo/doppelserver.svg)](https://travis-ci.org/drewcoo/doppelserver)
[![CircleCI](https://circleci.com/gh/drewcoo/doppelserver.svg?style=shield)](https://circleci.com/gh/drewcoo/doppelserver)
[![AppVeyor](https://ci.appveyor.com/api/projects/status/ho7j5joad8hk867s?svg=true)](https://ci.appveyor.com/project/drewcoo/doppelserver)
[![Coverage Status](https://coveralls.io/repos/github/drewcoo/doppelserver/badge.svg?branch=master)](https://coveralls.io/github/drewcoo/doppelserver?branch=master)
[![Gem Version](https://badge.fury.io/rb/doppelserver.svg)](https://badge.fury.io/rb/doppelserver)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/dd50d7ee18ae46c38ad053cf3dc59794)](https://www.codacy.com/app/drewcoo/doppelserver?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=drewcoo/doppelserver&amp;utm_campaign=Badge_Grade)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/doppelserver`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Why Doppelerver?

TODO: Explain mocks, dups, and fakes. This is a fake. Explain why fakes.

Also, all the cool names were taken on RubyGems.

## Installation

Add this line to your application's Gemfile:

    gem 'doppelserver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install doppelserver

## Usage

Scenarios this should cover:
* Fake a server from your (integration) tests
  * Default behaviors
    * Imagine a really stupid CRUD database backing the test server,
      one that auto-created schema as it went. That's pretty much it.
      How? Easy. Instead of a db it's just a hash in memory. Dumb? Yup.
  * Overrides
    * Control endpoints
* Run interactively (irb/pry console?) while debugging your code
* Record endpoint usage?
* Types of service:
  * REST-ish
  * GraphQL
  * Others? (WSDL?)
* Client bindings? Not sure that makes sense unless it's POROs or x-language.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rake` to run the tests.

To install this gem onto your local machine, run

    bundle exec rake install

To release a new version, update the version number in `version.rb` like so

    bundle exec gem bump -v [major|minor|patch|pre|release]

and then run

    bundle exec rake release

which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drewcoo/doppelserver.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
