# data_mask

This gem is made for data-masking. Dependent [Sequel](https://github.com/jeremyevans/sequel).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_mask'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_mask

## Usage

Make your `database.yml` & `tasks.yml` imitated with examples in `test/config`

And use the gem like this:

```ruby
mask = DataMask::Mask.new('path/with/your/database.yml_&_tasks.yml') # Default 'config/'
mask.run
```

or
```ruby
mask = DataMask::Mask.new('path/with/your/database.yml_&_task.yml') # Default 'config/'
mask.tmp_db_clear
mask.operate_db('create')
mask.migrate
mask.play
```

And you may use `mask.export` to export the database to *.sql* file.

In `.yml` files, you can use `%=` for eval the content.

You can also write yml like this: 

```yml
password: '%= BCrypt::Password.create("123456")'
```

And what you need to do is only `require 'bcrypt'`.


If you need to set each row with different value, you can just use `each_row`, like:
```yml
users:
  mobile: 18600000000
  each_row:
    email: '%= row[:id].to_s + "@zhulux.qa"'
```
the `row` this the object of each row, which type is Hash.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cuebyte/data_mask. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License
Authored by [cuebyte](https://github.com/cuebyte). Copyright (c) 2015 [ZhuluX Team](https://github.com/zhulux/).

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

