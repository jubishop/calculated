# Calculated

[![Rubocop Status](https://github.com/jubishop/calculated/workflows/Rubocop/badge.svg)](https://github.com/jubishop/calculated/actions/workflows/rubocop.yml)

A Ruby library for calculated.gg's undocumented API.

## Installation

### Global installation

```zsh
gem install calculated --source https://www.jubigems.org/
```

### In a Gemfile

```ruby
gem 'calculated', source: 'https://www.jubigems.org/'
```

## Usage

```ruby
Calculated::API.ranks(ENV['STEAM_ID'])
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
