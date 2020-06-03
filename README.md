# Vanilla jsConnect Client Library for Ruby #

This repository contains the files you need to use Vanilla's jsConnect with a ruby/rails project.

Documentation about the purpose of jsConnect is available on [our knowledge base](https://success.vanillaforums.com/kb/articles/206-upgrading-jsconnect-to-version-3)

## Installation

These jsConnect libraries are more or less platform agnostic. In order to use them you'll need to add the following:

* [The **jwt** gem](https://rubygems.org/gems/jwt). You can add it to your Gemfile with `gem "jwt"`.
* [`lib/js_connect_v3.rb`](https://github.com/vanillaforums/jsConnectRuby/blob/master/lib/js_connect_v3.rb)
  This is the main file you need. You don't need any other file in your project. You can just drop this file anywhere that you can access it on your site.
* [`lib/js_connect.rb`](https://github.com/vanillaforums/jsConnectRuby/blob/master/lib/js_connect.rb)
  This is the previous version of jsConnect. You can use this alongside `JsConnectV3` to support both the v2 and v3 protocols.
* [`app/controllers/sso_controller.rb`](https://github.com/vanillaforums/jsConnectRuby/blob/master/app/controllers/sso_controller.rb)
  This file is an example rails controller. You can drop this file into your rails application or start from scratch.
  Please note that if you use this file you'll also have to add a route to your rails config.
