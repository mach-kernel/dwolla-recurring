# dwolla-recurring
A quickstart tutorial application written in Rails 4 + bootstrap to illustrate recurring transactions in the Dwolla API.

![Ooh! Pretty!](http://puu.sh/htYFn/1d9afd6b3e.png)

## Requirements
- Rails 4+
- Bundler

This application does not require any database access as all the data is processed via the Dwolla API. ActiveRecord has been removed from this project. 

## Getting Started

### The easy way

The default application key and secret bundled with the application are for you to use with the UAT environment, so you can just run it!

```bash
git clone https://github.com/mach-kernel/dwolla-recurring.git
cd dwolla-recurring
bundle install && rails s
```

Afterwards, just visit your default Rails URL, which is probably `localhost:3000`.

### Hurt me plenty

Just kidding. The only thing that you would really need to configure are the `dwolla-ruby` variables. You can find everything that you need in `config/initializers/dwollavars.rb`

```ruby
require 'dwolla'

module DwollaVars
	mattr_reader  :Dwolla, :redirect

	@@key ||= "OFvc0S1ccEhgI/qJleEsIQQBdb3/mReQMkaNQmFbbo8PaAAtYI"
	@@secret ||= "oi6jXUSXVN1MuB0YT6X5WV/Alhv9MZdtDLSd71h6HOLRpu6fSf"

	@@redirect ||= "http://localhost:3000/dashboard/handle_oauth"

	@@Dwolla ||= Dwolla
	@@Dwolla::api_key ||= @@key
	@@Dwolla::api_secret ||= @@secret
	@@Dwolla::sandbox ||= true
end
```

**Note**: These values cannot be edited on-the-fly (except from within a `rails c` session) and require a restart of the rails server. 

## Deploy to Heroku

### Requirements

- A [Heroku](https://heroku.com) account with an available instance.
- The [Heroku Toolbelt](https://toolbelt.heroku.com/) installed to your local machine (and added to your `%PATH%` variable if you are a Windows user).
- I recommend forking this repository so that you can have write privileges. 

### How-to deploy: the easy-peasy way

*Please* fork this repository before doing this.

1. Connect your GitHub account in your Heroku admin panel

2. Search for your repository

	![Search](https://s3.amazonaws.com/heroku.devcenter/heroku_assets/images/421-original.jpg)

3. Deploy a branch

	![Deploy](https://s3.amazonaws.com/heroku.devcenter/heroku_assets/images/422-original.jpg)

### How-to deploy: the devops special

1. Log in
    ```bash
    heroku login
    
    Enter your Heroku credentials.
    Email: you@example.com
    Password:
    Could not find an existing public key.
    Would you like to generate one? [Yn]
    Generating new SSH public key.
    Uploading ssh public key /Users/david/.ssh/id_rsa.pub
    ```

2. Install Rails
    ```bash
    gem install rails
    ```

3. Add Heroku gem, change `redirect`

    I would have done this for you, but this is more fun!
    
    ```bash
    echo "gem 'rails_12factor'" >> Gemfile
    bundle install
    ```
    
    And now, let's edit `config/initializers/dwollavars.rb` to change our callback URI to something appropriate (your instance's publically facing hostname is a good idea, but do not remove `dashboard/handle_oauth`)!
    ```ruby
	module DwollaVars
		...
	
		@@redirect ||= "http://localhost:3000/dashboard/handle_oauth"
		
		...
	end
    ```

4. Drop back to your local machine's shell and change to the application directory

    This will add a heroku branch to the git repository
    
    ```bash
    heroku create
    Creating dwolla-rails-heroku... done, stack is cedar-14
    https://dwolla-rails-heroku.herokuapp.com/ | https://git.heroku.com/dwolla-rails-heroku.git
    Git remote heroku added
    ```

And finally, deploy and run.

```bash
git push heroku master
heroku ps:scale web=1
```

That wasn't so bad, was it?

## Credits

Written with love by [David Stancu](http://davidstancu.me) for [Dwolla Inc.](https://developers.dwolla.com)

## License

Copyright (C) 2015 David Stancu, Dwolla Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
