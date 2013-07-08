# Mmailer

## Rationale

The purpose of Mmailer is to allow the sending of personalized bulk email, like a newsletter, through regular SMTP providers (Gmail).
Regular SMTP providers imposes restrictions on how much mail you can send. Because various throttling strategies are used, and because they are not  always explicit, it is sometimes difficult to know where you stand with bulk email.
Mmailer is flexible, and it well help you make sure you stay within those limits, whatever they may be.
You can tell Mmailer to randomize the interval between the sending of emails, how long it should wait after a number of emails have been sent, pause the mail queue, resume it at will...

## Installation

    $ gem install mmailer

## Usage

All functionality is invoked via the gem's binary, mmailer.

    $ mmailer

### Server

You start the server in a terminal.

    $ mmailer server

### Remote control

You issue commands in a separate terminal. To start sending emails, run:

    $ mmailer start

To pause:

    $ mmailer pause

To resume:

    $ mmailer resume

To stop:

    $ mmailer stop

To restart from  the 56th element in your queue (more on this later).

    $ mmailer start 56

### Bundler

Although this gem performs as a standalone program, nothing prevents you from adding the following in a project's Gemfile:

    gem 'mmailer'

And then execute:

    $ bundle


In this case, you can run
```ruby
bundle exec mmailer
```

## Configuration

The big advantage of `mmailer` is that it doesn't require any external code to operate. Instead, you configure it.
You need to provide three things in order to let `mmailer` send bulk email.

  * a configuration file
  * template files
  * environment variables

### Configuration

Here is what a sample configuration file looks like:
```ruby
Mmailer.configure do |config|
  config.provider = :google
  config.from = 'Etsy Fu <info@shopi-fu.com>'
  config.subject = "Test"
  config.template = "test"
  config.collection = Proc.new do
    User = Struct.new(:email)
    [User.new("first@email.com"), User.new("second@email.com"), User.new("third@email.com")]
  end
  config.time_interval = 6
end
```

* `from`: The from address.
* `subject`: The subject.

### Templates

Templates are the body of your mail. They use erb

### Environment variables

Ruby can load environment variables for you. It is thus convenient to put them at the top of `config.rb`
```ruby
ENV['GMAIL_USERNAME']="username"
ENV['GMAIL_PASSWORD']="password"
ENV['MMAILER_ENV'] = "production"
```

## Implementation

* Drb
* State machine
* CLI

## TODO

* [] Web interface
* [] Command-line interface
* [] Documentation

## Spam & motivation

Spam is evil. This is not a spammer's tool. I wrote this so as to send a newsletter to my users.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
