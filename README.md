# browserslist_useragent gem [![Build Status](https://travis-ci.org/dsalahutdinov/browserslist-useragent.svg?branch=master)](https://travis-ci.org/dsalahutdinov/browserslist-useragent)

<img align="right" width="120" height="120"
     src="https://github.com/browserslist/browserslist/blob/master/logo.svg" alt="Browserslist logo by Anton Lovchikov">

Find if a given user agent string satisfies a [browserslist](https://github.com/ai/browserslist) query.

Make browser version control easy at both front-end and back-end, share one config with modern front-end tools.

[Browserslist](https://github.com/ai/browserslist) - Library to share target browsers between different front-end tools.
It is used in
[Autoprefixer](https://github.com/postcss/autoprefixer),
[babel-preset-env](https://github.com/babel/babel/tree/master/packages/babel-preset-env),
[postcss-preset-env](https://github.com/jonathantneal/postcss-preset-env) and many other tools.


## Gem usage

`BrowserslistUseragent::Match` - is the main class performing matching user agent string to browserslist.

It provides 2 methods:
 - `version?(allow_higher: false)` - determines matching browser and its version
 - `browser?` - determines matching only borwser family:

```ruby
require 'browserslist_useragent'

matcher = BrowserslistUseragent::Match.new(
  ['Firefox 53'],
  'Mozilla/5.0 (Windows NT 10.0; rv:54.0) Gecko/20100101 Firefox/53.0'
)
matcher.browser? # returns true
matcher.version? # return true

matcher = BrowserslistUseragent::Match.new(
  ['Firefox 54'],
  'Mozilla/5.0 (Windows NT 10.0; rv:54.0) Gecko/20100101 Firefox/53.0'
)
matcher.browser? # returns true
matcher.version? # return false
```

### Use case "Unsupported Browser" detection

```ruby
SUPPORTED_BROWSERS = [
  'chrome 64', 'chrome 65', 'firefox 58', 'opera 50', 'safari 11'
]

def supported_browser?(user_agent)
  BrowserslistUseragent::Match.new(SUPPORTED_BROWSERS, user_agent).version?
end
```

### Use case "Outdated Browser" detection

```ruby
MODERN_BROWSERS = [
  'chrome 64', 'chrome 65', 'firefox 58', 'opera 50', 'safari 11'
]

def outdated_browser?(user_agent)
  match = BrowserslistUseragent::Matcher.new(MODERN_BROWSERS, user_agent)
  match.browser? && match.version?(allow_higher: true)
end
```

## Installation

```ruby
# add to your Gemfile
gem 'browserslist_useragent'

# than run
bundle install
```

## Supported browsers

Chrome, Firefox, Safari, IE, Edge
 
PRs to add more _browserslist supported_ browsers are welcome 👋

## Notes
 - All browsers on iOS (Chrome, Firefox etc) use Safari's WebKit as the underlying engine, and hence will be resolved to Safari. Since `browserslist` is usually used for
  transpiling / autoprefixing for browsers, this behaviour is what's intended in most cases, but might surprise you otherwise.
  
 - Right now, Chrome for Android and Firefox for Android are resolved to their desktop equivalents. The `caniuse` database does not currently store historical data for these browsers separately (except the last version) See [#156](https://github.com/ai/browserslist/issues/156)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/browserslist-useragent.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
