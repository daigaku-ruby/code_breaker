# CodeBreaker

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
gem 'code_breaker', github: 'daigaku-ruby/code_breaker'
```

And then execute:

    $ bundle

Or download and install it yourself as:

    $ git clone git@github.com:daigaku-ruby/code_breaker.git
    $ cd code_breaker
    $ rake install

## Usage

You can break a Ruby code snippet into its receivers and called method:

```ruby
require 'code_breaker'

code_snippet = 'crazy_number = Rational(3, 5) + 42 - Complex(2.3, 6.4) * 1.2'
CodeBreaker.parse(code_snippet)
# => [Rational, :+, Fixnum, :-, Complex, :*, Float]
```

You can also use the Parser class directly:

```ruby
parser = CodeBreaker::Parser.new(code_snippet)
parser.run
# => [Rational, :+, Fixnum, :-, Complex, :*, Float]

parser.input
# => 'crazy_number = Rational(3, 5) + 42 - Complex(2.3, 6.4) * 1.2'

parser.output
# => [Rational, :+, Fixnum, :-, Complex, :*, Float]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daigaku-ruby/code_breaker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

