# Doppelserver

[![TravisCI](https://api.travis-ci.org/drewcoo/doppelserver.svg)](https://travis-ci.org/drewcoo/doppelserver)
[![CircleCI](https://circleci.com/gh/drewcoo/doppelserver.svg?style=shield)](https://circleci.com/gh/drewcoo/doppelserver)
[![AppVeyor](https://ci.appveyor.com/api/projects/status/ho7j5joad8hk867s?svg=true)](https://ci.appveyor.com/project/drewcoo/doppelserver)
[![Coverage Status](https://coveralls.io/repos/github/drewcoo/doppelserver/badge.svg?branch=master)](https://coveralls.io/github/drewcoo/doppelserver?branch=master)
[![Gem Version](https://badge.fury.io/rb/doppelserver.svg)](https://badge.fury.io/rb/doppelserver)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/dd50d7ee18ae46c38ad053cf3dc59794)](https://www.codacy.com/app/drewcoo/doppelserver?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=drewcoo/doppelserver&amp;utm_campaign=Badge_Grade)


## What's Doppelerver?

Welcome to Doppelserver, the fake RESTful service gem, so named because all the cool names were already taken on RubyGems.

Chances are you're already using some kind of double in your testing. Test
doubles fit into several categories:
  - stubs - objects with values chosen to make tests pass
  - mocks - objects with running code that's set to make tests pass
  - spies - objects that can be queried for what happened to them
  - fakes - actual running objects but incomplete and instrumented

Martin Fowler [has a good explanation](https://martinfowler.com/articles/mocksArentStubs.html) but he separates what I'm calling stubs into "stubs" that respond with what a test needs and "dummies" that are passed but never accessed.

In this case we're talking about a fake service, an actual running service intended to replace what you'd normally have in production for test purposes. It should respond as the actual service would but is instrumented so that you can both ask what happened like a spy and, more importantly, tell it how to respond differently because it's a fake.


## Installation

Add this line to your application's Gemfile:

    gem 'doppelserver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install doppelserver


## Usage


### Manually Exploring
There's a command line tool, scc.rb, to explore what Doppelserver does:

    $ bin/scc.rb help
    Commands:
      scc.rb data            # send/retreive all data
      scc.rb help [COMMAND]  # Describe available commands or one specific command
      scc.rb restart         # restart server, dumping all data
      scc.rb start           # start server
      scc.rb stop            # stop server

    Options:
      -p, [--port=PORT]  # port service runs on
                         # Default: 7357


#### Basics

So let's just start it, defaulting to port 7357 (which is leet speak for "test").

    $ bin/scc.rb start

It's now running and you can use your favorite tool to run RESTful queries on it. I'll suggest [Postman](https://www.getpostman.com/) if you don't have anything. The fake service understands plural collections and items in them with (non-negative) integer ids. So you can get the initial things collection:

    GET http://localhost:7357/things

It returns a 200 but no data because it's currently empty. Let's put something in it.

    POST http://localhost:7357/things
and send this data:
    { "name": "first", "another_value": "second" }

Now we get a 200 back because we succeeded. Succeeded at what? Let's see:

    GET http://localhost:7357/things

That 200s and returns this:

    {
        "0": {
            "name": "first",
            "another_value": "second"
        }
    }

You can also retrieve by index.

    GET http://localhost:7357/things/0
returns:
    {
        "name": "first",
        "another_value": "second"
    }

In general, this will behave like an in-memory CRUD store. That starts and stops and restarts. So much for basics . . .

    $ bin/scc.rb stop


#### Controlling the Data

There is a control endpoint that does more for us.


##### Running

Yes, this returns { "status": "running" } if running:

    GET http://localhost:7537/control


##### Data

You can look at or change all of the data either with the /control/data endpoint or with the command line tool's data command.

If you want to have the server not respond do this:
  1. get data (optionally save somewhere)
  2. stop service
  3. run query-to-fail against service
  4. start service
  5. restore data


##### Version Numbers Et Al.

To support urls with things like version numbers the service already supports urls like this:

    http://localhost/<ADDITONAL_STRING>/collection/1

Where <ADDITIONAL_STRING> is any string. That means GETting and POSTing these is the same:

    http://localhost/collection/0
    http://localhost/FOO/collection/0
    http://localhost/v1/BAR/BAZ/collection/0


## TODO

I should still add this functionality:
  - return non-REST data (possibly non-HTTP)
  - GraphQL? Some subset of it?
  - Others? WSDL?
  - Client bindings? POROs?


## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rake` to run the tests.

To install this gem onto your local machine, run

    $ bundle exec rake install

To release a new version, update the version number in `version.rb` like so

    $ bundle exec gem bump -v [major|minor|patch|pre|release]

and then run

    $ bundle exec rake release

which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drewcoo/doppelserver.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
