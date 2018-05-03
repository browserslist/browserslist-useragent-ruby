# browserslist_useragent gem [![Build Status](https://travis-ci.org/dsalahutdinov/browserslist-useragent.svg?branch=master)](https://travis-ci.org/dsalahutdinov/browserslist-useragent)

<img align="right" width="120" height="120"
     src="https://github.com/browserslist/browserslist/blob/master/logo.svg" alt="Browserslist logo by Anton Lovchikov">

Find if a given user agent string satisfies a [browserslist](https://github.com/ai/browserslist) query.

Make browser version control easy at both front-end and back-end, [share one config with modern front-end tools](#advanced-mode).

[Browserslist](https://github.com/ai/browserslist) - Library to share target browsers between different front-end tools.
It is used in
[Autoprefixer](https://github.com/postcss/autoprefixer),
[babel-preset-env](https://github.com/babel/babel/tree/master/packages/babel-preset-env),
[postcss-preset-env](https://github.com/jonathantneal/postcss-preset-env) and many other tools.


## Use gem with browserslist tool

### Setup browserslist

Run in webpack directory to install `browserslist` npm package:

```sh
npm install --save-dev browserslist
```

Put this lines of code to `webpack/config.js` to generate `browsers.json` automatically:

```javascript
const browserslist = require('browserslist')
const fs = require('fs')

fs.writeFileSync('./browsers.json', JSON.stringify(browserslist()))
```

Read more details about browserslist [here](https://github.com/browserslist/browserslist#browserslist-).

### Use gem to find if user_agent satisfies provided browserslist
Read json file and pass it to gem (with user_agent):

```ruby
# read generates browserslist
browsers = JSON.parse(File.read('browsers.json'))
BrowserslistUseragent::Match.new(browsers, request.user_agent).version?
```

## Gem usage
`BrowserslistUseragent::Match` - is the main class performing matching user agent string to browserslist.

It provides 2 methods:
 - `version?(allow_higher: false)` - determines matching browser and it's version
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

## Advanced mode

If you have ruby backend and nodejs frontend working separately, maybe you will prefer to share one 
browserslist over http.

Share `browsers.json` file moving it to `public` directory:

```javascript
fs.writeFileSync(
  path.join(__dirname, '..', 'public', 'browsers.json'),
  JSON.stringify(browserslist(undefined, { path: path.join(__dirname, '..') }))
)
```
Do not forget to put file to `.gitignore`.

Gets `browserslist.json` over http (with caching) once (per web application instance) and use it to match user_agent for every request:
```ruby
# caches http response locally with etag
http_client = Faraday.new do |builder|
  builder.use Faraday::HttpCache, store: Rails.cache
  builder.adapter Faraday.default_adapter
end
@browsers = JSON.parse(
  http_client.get(FRONTEND_HOST + '/browsers.json').body
)
# somewhere in request processing
matcher = BrowserslistUseragent::Match.new(@browsers, user_agent)
modern_browser = matcher.browser? && matcher.version?
```

## Gem installation

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
