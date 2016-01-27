# Spell

Spell checker written in pure Ruby, implementing a simple bigram comparison algorithm. Spell has no external dependencies (including aspell or ispell).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spell'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spell

## Usage

The spell initializer can take one or two arguments.

You must provide a hash where the keys are the words and the values are the corresponding word counts. If you do not care to factor in word counts, the values may all be `0`.

The default for the word usage weight (internally termed "alpha") is 0.3. This value should be in the range 0.0-1.0, where 0.0 means the word usage does not affect the output, whereas 1.0 means the most used word is always returned.

If you want to accept the default weight, you can simply write:
```ruby
word_list = { "alpha" => 2, "beta" => 20 }
spell = Spell::Spell.new(word_list)
spell.best_match('alphabet')  #=> "alpha"
```

Or, if you'd rather specify a custom word weight, you can specify it like this:
```ruby
word_list = { "alpha" => 2, "beta" => 20 }
spell = Spell::Spell.new(word_list, 0.5)
spell.best_match('alphabet')  #=> "beta"
```

Other than the `best_match` method, shown above, there is also a method `compare`, which returns the how similar two words are, based on shared, order-consistent bigrams compared to the maximum number of bigrams of the two words.

```ruby
...
spell = Spell::Spell.new(word_list)
spell.compare('alpha', 'alphabet')  #=> 0.5714285714285714 (4 / 7)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/J3RN/spellrb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

