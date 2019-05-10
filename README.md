# Aspentech IP21 Ruby Gem

With this gem you will be able to connect to IP21 and execute queries against the database using SQL statements.

## Installing

To install this gem, use the following command:

```sh
$ gem install ip21
```

Or add to your Gemfile:

```ruby
# Gemfile
gem 'ip21'
```

And use the class in your code to execute queries:

```ruby
require 'ip21' # If you are using Ruby. Don't need require if you use Rails

IP21.new(
    auth: {
        account: 'john.doe',
        domain: 'contoso.com',
        password: 'set_your_own_password'
    },
    sqlplus_address: '127.0.0.1',
    ip21_address: '127.0.0.1',
).query('SELECT IP_PLANT_AREA, Name, IP_DESCRIPTION FROM IP_AnalogDef')
```

## Prerequisites

- IP21 Database
- SQLPlus with REST or SOAP Web Service installed

## Authentication

This gem uses Windows authentication to connect to SQLPlus, so don't forget to set your credentials correctly.

On domain you can use the NETBIOS name (CONTOSO) or the normal domain name (contoso.com)

# Changelog
See the [commit page](https://github.com/rhuanbarreto/ip21-ruby/commits) for a list of changes.

# License
IP21 Gem by Rhuan Barreto. IP21 Gem is licensed under the MIT license. Please see the LICENSE file for more information.