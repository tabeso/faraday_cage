# Faraday Cage

* Code: [github.com/tabeso/faraday_cage](https://github.com/tabeso/faraday_cage)

## Description

Faraday Cage allows you to use [Faraday](https://github.com/lostisland/faraday)
for making requests to your APIs in integration testing, minus the boilerplate
code and repeated parsing and encoding of requests and responses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday_cage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_cage

## Usage with RSpec

Load RSpec support by adding the following to your `spec_helper.rb`:

```ruby
require 'faraday_cage/rspec'
```

Configure the middleware you would like to use (see
[Faraday](https://github.com/lostisland/faraday) and
[faraday_middleware](https://github.com/lostisland/faraday_middleware) for more
information):

```ruby
FaradayCage.middleware do |conn|
  conn.request  :json
  conn.response :mashify
  conn.response :json, content_type: /\bjson$/

  conn.options[:preserve_raw] = true
end
```

You will now be able to test your app like so:

```ruby
describe 'creating a gist' do

  before do
    header :accept, 'application/vnd.github.v3'
    basic_auth 'username', 'password'
  end

  let(:gist) do
    {
      description: 'This is my gist, there are many like it but this one is mine.',
      public: true,
      files: [
        'file1.txt' => {
          content: 'cool beans'
        }
      ]
    }
  end

  subject { post 'gists', gist }

  its(:status) { should be_created }

  it 'references the location of the created gist' do
    body[:url].should =~ %r{^https://api.github.com/gists/[a-f0-9]+$}
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
