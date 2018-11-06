# browserslist_useragent gem
[![Gem Version](https://badge.fury.io/rb/browserslist_useragent.svg)](https://badge.fury.io/rb/browserslist_useragent)
[![Build Status](https://travis-ci.org/browserslist/browserslist-useragent-ruby.svg?branch=master)](https://travis-ci.org/browserslist/browserslist-useragent-ruby)

<img align="right" width="120" height="120"
  src="https://cdn.rawgit.com/pastelsky/browserslist-useragent/master/logo.svg" alt="Browserslist Useragent logo (original by Anton Lovchikov)" />

Find if a given user agent string satisfies a [Browserslist](https://github.com/ai/browserslist) browsers.

[Browserslist](https://github.com/browserslist/browserslist) is a popular config in many front-end tools like [Autoprefixer](https://github.com/postcss/autoprefixer) or [Babel](https://github.com/babel/babel/tree/master/packages/babel-preset-env). This gem allow you to use this config in Ruby project to check user agent string and, for examplle, show “Your browsers is outdated” warning for user with old browser.

## Usage

### 1. Setup Browserslist

Run in webpack directory to install `browserslist` npm package:

```sh
npm install --save-dev browserslist
```

Put this lines of code to webpack config to generate `browsers.json` during build step:

```javascript
const browserslist = require('browserslist')
const fs = require('fs')

fs.writeFileSync('./browsers.json', JSON.stringify(browserslist()))
```

Put `browsers.js` file to `.gitignore`.

### 2. Install gem

Add this line to `Gemfile`

```ruby
gem 'browserslist_useragent'
```

Run `bundle install`.

### 3. Add helper

Define new helper in `app/helpers/application_helper.rb`:

```ruby
def supported_browser?
  @browsers ||= JSON.parse(File.read(PATH_TO_BROWSERS_JSON))
  matcher = BrowserslistUseragent::Match.new(@browsers, request.user_agent)
  matcher.browser? && matcher.version?(allow_higher: true)
end
```

### 4. Use helper in template

Put a warning message for users with an unsupported browser in `app/views/layouts/_unsupported_browser_warning` and add this check in application layout:

```haml
body
  - if !supported_browser?
    render 'layouts/unsupported_browser_warning'
```

### Separated projects

If you have separated projects for Ruby backend and Node.js frontend, you will prefer to get `browsers.json` over HTTP.

```javascript
fs.writeFileSync(
  path.join(__dirname, 'public', 'browsers.json'),
  JSON.stringify(browserslist(undefined, { path: path.join(__dirname, '..') }))
)
```

Gets `browserslist.json` over HTTP (with caching) once (per web application instance) and use it to match user agent for every request:

```ruby
# caches http response locally with etag
http_client = Faraday.new do |builder|
  builder.use Faraday::HttpCache, store: Rails.cache
  builder.adapter Faraday.default_adapter
end

@browsers = JSON.parse(
  http_client.get(FRONTEND_HOST + '/browsers.json').body
)
```

## API
`BrowserslistUseragent::Match` is the main class performing matching user agent string to browserslist.

It provides 2 methods:
 - `version?(allow_higher: false)` - determines matching browser and it's version
 - `browser?` - determines matching only borwser family

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

## Supported browsers

Chrome, Firefox, Safari, IE, Edge
 
PRs to add more _browserslist supported_ browsers are welcome 👋

## Notes

* All browsers on iOS (Chrome, Firefox etc) use Safari's WebKit as the underlying engine, and hence will be resolved to Safari. Since `browserslist` is usually used for
  transpiling / autoprefixing for browsers, this behaviour is what's intended in most cases, but might surprise you otherwise.
* Right now, Chrome for Android and Firefox for Android are resolved to their desktop equivalents. The `caniuse` database does not currently store historical data for these browsers separately (except the last version) See [#156](https://github.com/ai/browserslist/issues/156)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/browserslist-useragent-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
