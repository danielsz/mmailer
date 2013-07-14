# Mmailer

## Rationale

The purpose of Mmailer is to allow the sending of personalized bulk email, like a newsletter, through regular SMTP providers (for example Gmail).
Regular SMTP providers imposes restrictions on how much mail you can send. Because various throttling strategies are used, and because they are not  always explicit, it is sometimes difficult to evaluate whether you will succeed in sending that newsletter of yours to all of your users.

Mmailer is flexible, and well help you make sure you stay within those limits, whatever they may be. Mmailer is backend agnostic. Nor does it make any assumptions on data formats. It will process the objects you feed it. You can tell Mmailer to randomize the interval between the sending of emails, how long it should wait after a number of emails have been sent, pause the mail queue, resume it at will...

Is it any good?
---

[Yes][y].

[y]: http://news.ycombinator.com/item?id=3067434

## Installation

    $ gem install mmailer

## Usage

All functionality is invoked via the gem's binary, mmailer.

    $ mmailer

## Principle of operation

A server runs behind the scenes, managing the email queue, and you send it commands to start, pause, resume or stop.

### Server

You start the server in a terminal.

    $ mmailer server

### Remote control

You issue commands in a separate terminal. To start sending emails, type:

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

`mmailer` doesn't require any external code to operate. Instead, you configure it.
You need to provide three things in order to let `mmailer` send bulk email.

  * a configuration file
  * template files
  * environment variables

### Configuration file

Mmailer will look for a file name `config.rb` in the directory where you run it. Here is what a sample configuration file looks like:
```ruby
Mmailer.configure do |config|
  config.provider = :gmail
  config.from = 'Daenerys Targaryen <daenerys@house_targaryen.com>'
  config.subject = "Fire and Blood"
  config.time_interval = 6          #optional, default value is 6 seconds
  config.mail_interval = 48         #optional, default value is 48 emails
  config.sleep_time = 3600          #optional, default value is 3600 seconds
  config.template = "newsletter"
  config.collection = lambda do
    User = Struct.new(:email, :name)
    [User.new("first@email.com", "Greyjoy"), User.new("second@email.com", "Lannister"), User.new("third@email.com", "Martell")]
  end
end
```

* `from`: The from address that will be used in your emails.
* `subject`: The subject of your email.
* `provider`: The name of your provider. These are preset. For the moment, one of `:gmail`, `:zoho` or `:mandrill`. Please add more providers via pull requests or by sending me mail.
* `time_interval`: The number of seconds we want to wait between emails. We use this value as a ceiling when randomizing.
* `mail_interval`: After how many emails we wait before continuing.
* `sleep_time`: How long we wait when we reach the mail interval.
* `collection`: An array of objects that respond to an `email` message. In the above example, the objects also respond to a `name` message. This will prove handy in templates. Instead of directly providing the array, it is recommended to specify a lambda that returns said array. You will then be able to make expensive calls to your database, bringing as many objects as memory permits, without impacting the server startup time.
* `template`: The path (relative to the current directory) and filename to the ERB templates for your mail, without suffix. For example, "newsletter". This means your template files are actually "newsletter.txt.erb" and "newsletter.html.erb" in the current directory.

### Templates

Templates are the body of your mail. They use the ERB templating system. Each element in your collection is available from within the template. (Much like Rails passes the instance variables from the controller to the views). Based on the collection in the previous example, a sample template would look like this:

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

## Real world examples

### Mongodb

This will show you how to use Mmailer when your data lives in Mongodb. We are going to use mongoid to make the queries.

Make a directory and create the configuration file and template files like previously described.

The `config.rb` would look like this:

```ruby
ENV['GMAIL_USERNAME']="username"
ENV['GMAIL_PASSWORD']="password"
ENV['MMAILER_ENV'] = "development"

require "rubygems"
require "mongoid"
require_relative "mongo_helper"

Mmailer.configure do |config|
  config.provider = :gmail
  config.subject = "My newsletter"
  config.template = "newsletter"
  config.collection = lambda { User.all.entries }
  config.time_interval = 6
  config.from = 'John Doe <john@example.com>'
end
```

Copy your mongoid.yml from your production system in the current directory. And create a mongo_helper.rb with your domain models.

```ruby
Mongoid.load!(File.join(Dir.pwd, "mongoid.yml"), :production)

class User
  include Mongoid::Document
  has_many :profiles
  ... #the rest of your relations
end

class Profile
    include Mongoid::Document
end

... #the rest of the model classes that User references
```

The content of your directory would thus look something like this:

```bash
ls -l
total 40
-rw-r--r--  1 daniel  1000   424 יול 14 03:43 config.rb
-rw-r--r--  1 daniel  1000  3587 יול 10 04:08 mongo_helper.rb
-rw-r--r--  1 daniel  1000  3027 יול 10 03:39 mongoid.yml
-rw-r--r--  1 daniel  1000    81 יול 14 03:44 newsletter.html.erb
-rw-r--r--  1 daniel  1000    60 יול 14 03:44 newsletter.txt.erb
```

You are now ready to send your newsletter. In one terminal, type `mmailer server`, in another type `mmailer start`. Output will be displayed in the server terminal.

### More examples

More configuration examples soon. (Please don't hesitate to contribute your configurations.)

## Architecture & Implementation

### DRb

The server exposes an object representing the state of your queue (started/stopped/paused). When the client asks the server to start sending email, the server spawns a thread which will subsequently check on that state object after each email sending, thus knowing if it should proceed, halt, or change behavior in other ways. DRb is used to implement this model.

### State machine

We use MicroMachine, a minimal finite state machine, to help with the state transitioning.

### Mail

We leverage the ubiquitous Mail gem to do the actual sending of email.

### CLI

We used Thor to provide a command line interface.

### Web interface

This program will be best served with some sort of GUI. A web-based interface (using Sinatra) is under consideration.

## Status

This is an initial release. Currently, no checks or sanitation is done when parsing the configuration. Mmailer will just blow up when an error is encountered. At this early stage, the project targets power users and contributors. Others may want to wait for a later release that will hopefully sport a web interface with better usability.

## TODO

* [] Web interface
* [X] Command-line interface
* [] Documentation
* [] Test suite

## Spam

Mmailer is a bulk mail sending tool. Don't use it for spamming purposes. Spam is evil.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
