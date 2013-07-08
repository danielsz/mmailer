# Mmailer

## Purpose

The purpose of this gem is to allow the sending of bulk email through regular smtp providers, like gmail.
Regular smpt providers imposes restrictions on how much mail you can send, with various throttling strategies.
is often applied on number of emails per hour, or per day

## Installation

    $ gem install mmailer

## Usage

All functionality is invoked via the gem's binary, mmailer.

    $ mmailer

### Bundler

Although this gem performs like a utility that runs standalone, nothing prevents you from adding the following in a project's Gemfile:

    gem 'mmailer'

And then execute:

    $ bundle


In this case, you can run
```ruby
bundle exec mmailer
```

## Configuration

The big advantage of mmailer is that it doesn't require any external code to operate. Instead, you configure it.
You need to provide three things in order to let mmailer send bulk email.

 * environment variables
 * a configuration file
 * template files

### Environment variables

### Configuration

### Templates

## Implementation


## TODO

* Web interface
* Command-line interface

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
