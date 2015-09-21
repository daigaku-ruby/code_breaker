# CodeBreaker

[![Build Status](https://travis-ci.org/daigaku-ruby/code_breaker.svg?branch=master)](https://travis-ci.org/daigaku-ruby/code_breaker)
[![Gem Version](https://badge.fury.io/rb/code_breaker.svg)](http://badge.fury.io/rb/code_breaker)

CodeBreaker breaks a line of Ruby code into its receiver classes and the methods
that are called on them.

The idea behind this is to make global lines of code like the following one testable:

```ruby
sum = Rational(2, 3) + 4
```

By breaking down this line into the receiver classes and called methods you can
check e.g. whether a code snippet assigns the sum of a Rational and a Fixnum to
a variable with the name `sum`.

Testing global code snippets might be important for testing the code of simple
programming tasks in learning tools like [Daigaku](https://github.com/daigaku-ruby/daigaku).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'code_breaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 'code_breaker'

## Usage

You can break a Ruby code snippet into its receivers and called method:

```ruby
require 'code_breaker'

code_snippet = 'crazy_number = Rational(3, 5) + 42 - Complex(2.3, 6.4) * 1.2'
CodeBreaker.parse(code_snippet)
# => {:lvasgn=>[:crazy_number, [Rational, :+, Fixnum, :-, Complex, :*, Float]]}

code_snippet = '"hello" + "World"'
CodeBreaker.parse(code_snippet)
# => [String, :+, String]
```

You can also use the Parser class directly:

```ruby
code_snippet = '"hello" + "World"'

parser = CodeBreaker::Parser.new(code_snippet)
parser.run
# => [String, :+, String]

parser.output
# => [String, :+, String]

parser.input
# => "\"hello\"+\"world\""
```

## Implemented syntax

For an overview of the implemented syntax and examples for certain parsed Ruby statement please see the project's [Wiki](https://github.com/daigaku-ruby/code_breaker/wiki).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daigaku-ruby/code_breaker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

