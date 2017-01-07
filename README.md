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

--------

In `.yml` files, you can use `%=` for eval the content.

You can also write yml like this: 

```yml
password: '%= BCrypt::Password.create("123456")'
```


If you need to set each row with different value, you can just use `each_row`, like:
```yml
users:
  mobile: 18600000000
  each_row:
    email: '%= row[:id].to_s + "@cuebyte.moe"'
```
the `row` this the object of each row, which type is Hash.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

