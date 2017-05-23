# Easy setup to do updates #

# Installing Ruby
```
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rbenv install 2.4.0
rbenv global 2.4.0
ruby -v
# ruby 2.4.0p0
```

# Installing Rails
```
gem install rails -v 5.0.1
rbenv rehash
rails -v
# Rails 5.0.1
```

# Start Rails

```
# On the repository folder
rails new jsConnectRuby
cd jsConnectRuby
rails server
```

Then go to http://localhost:3000/sso/index

*source https://gorails.com/setup/osx/10.12-sierra*
