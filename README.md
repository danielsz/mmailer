# Mmailer

## Rationale

The purpose of Mmailer is to allow the sending of personalized bulk email, like a newsletter, through regular SMTP providers (Gmail).
Regular SMTP providers imposes restrictions on how much mail you can send. Because various throttling strategies are used, and because they are not  always explicit, it is sometimes difficult to know where you stand with bulk email.
Mmailer is flexible, and it well help you make sure you stay within those limits, whatever they may be. Mmailer is backend agnostic. Nor does it make any assumptions on data formats. It will process the objects you feed it. You can tell Mmailer to randomize the interval between the sending of emails, how long it should wait after a number of emails have been sent, pause the mail queue, resume it at will...

Is it any good?
---

[Yes][y].

[y]: http://news.ycombinator.com/item?id=3067434

## Installation

    $ gem install mmailer

## Usage

All functionality is invoked via the gem's binary, mmailer.

    $ mmailer

### Principle of operation

A server runs behind the scenes, managing the email queue, and you send it commands to start, pause, resume or stop.

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
  config.time_interval = 6          #optional
  config.mail_interval = 48         #optional
  config.sleep_time = 3600          #optional
  config.template = "test"
  config.collection = lambda do
    User = Struct.new(:email, :name)
    [User.new("first@email.com", "Greyjoy"), User.new("second@email.com", "Lannister"), User.new("third@email.com", "Martell")]
  end
end
```

* `from`: The from address that will be used in your emails.
* `subject`: The subject of your email.
* `provider`: The name of your provider. These are preset. For the moment, Google, Zoho and Mandrill are defined. Please add more via pull requests or by sending me mail.
* `time_interval`: The number of seconds we want to wait between emails. We use this value as a ceiling when randomizing.
* `mail_interval`: After how many emails we wait before continuing.
* `sleep_time`: How long we wait when we reach the mail interval.
* `collection`: An array of objects that respond to an :email call. In the above example, the objects also respond to :name call. This will prove handy in templates. Instead of directly providing the array, it is highly recommended to specify a lambda that returns said array.
* `template`: The path and filename to the ERB templates for your mail, without suffix. For example, "template". This means your template files are actually "template.txt.erb" and "template.html.erb" in the current directory.

### Templates

Templates are the body of your mail. They use the ERB templating system. This means that you have access to each element of your collection inside the template. If you're familiar with Rails, you should recognize this. Based on the collection in the previous example, a sample template would look like this:

```ruby
Dear <%= user.name %>

This is my newsletter.

Yours.

```

And the equivalent html template.

```ruby
<p>Dear <em><%= user.name %></em>/p>
<p>This is my newsletter.</p>
<p>Yours.</p>
```

### Environment variables

Ruby can load environment variables for you. It is thus convenient to put them at the top of `config.rb`
```ruby
ENV['GMAIL_USERNAME']="username"
ENV['GMAIL_PASSWORD']="password"
ENV['MMAILER_ENV'] = "production"
```

* `MMAILER_ENV`: In production mode, emails get sent. In development mode, they get printed to STDOUT.
* `PROVIDER_USERNAME`: Username for the provider.
* `PROVIDER_PASSWORD`: Password for the provider.

You can define multiple pairs of usernames and passwords for the predefined providers.

### Examples


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
