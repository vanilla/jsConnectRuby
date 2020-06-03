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
  This file is an example rails controller. You can drop this file into your rails application or start from scratch. Please note that if you use this file you'll also have to add a route to your rails config.

## Usage

To use jsConnect you will need to make a web page that gives information about the currently signed in user of your site. To do this you'll need the following information:

- You will need the client ID and secret that you configured from within Vanilla's dashboard.
- The currently signed in user or if there is no signed in user you'll also need that.

### Basic Usage

Here is a basic rails controller that describes how to use jsConnect with the version 3 protocol.

```ruby
# This endpoint implements jsConnect v3.
# If you are implementing any new SSO for jsConnect use this method.
def sso
  jsc = JsConnectV3.new

  # 1. Configure your client ID and secret.
  jsc.set_client_id "123"
  jsc.set_secret "123"

  # 2. Set details of the current user or mark the connection as a guest.
  if @signed_in
    jsc.set_unique_id "123"
    jsc.set_name "John Ruby"
    jsc.set_email "john.ruby@example.com"
    jsc.set_photo_url ""
  else
    jsc.set_guest true
  end

  # 3. Get the redirect URL.
  begin
    url = jsc.generate_response_location self.params
    redirect_to url, :status => 302
  rescue StandardError => e
    # There could be an error too. Make sure to output an appropriate response.
    response.status = 400
    response.content_type = "text/plain"
    render :js => e.message
  end
end
```

The endpoint instantiates a `JsConnectV3` object and sets it up. It then calls `JsConnectV3::generate_response_location` with the current query string to process the request. You then 302 redirect to the location it returns.

If there is an error you will need to display it on your page. Remember to escape the message.

### Upgrading From Version 2 to Version 3

If you previously used the `JsConnect` module to implement your SSO, you will need to update its usage. Here are the steps you need to take:

1. Replace your call to `JsConnect.getJsConnectString` with a call to `JsConnect.getJsConnectResponse`.
2. Inspect the status of the response. If it is `302` then you need to redirect because it is a v3 request. If it is anything else then you need to render the output.

Here is an example:

```ruby
# This method supports both v2 and v3 of jsConnect.
# If you are upgrading your jsConnect you should look at this method.
def index
  # 1. Get your client ID and secret here. These must match those in your jsConnect settings.
  client_id = "123"
  secret = "123"

  # 2. Grab the current user from your session management system or database here.
  signedIn = true # this is just a placeholder

  # YOUR CODE HERE.

  # 3. Fill in the user information in a way that Vanilla can understand.
  user = {}

  if signedIn
    # CHANGE THESE FOUR LINES.
    user["uniqueid"] = "123"
    user["name"] = "John Ruby"
    user["email"] = "john.ruby@example.com"
    user["photourl"] = ""
  end

  # 4. Generate the jsConnect string.
  begin
    jsResponse = JsConnect.getJsConnectResponse user, self.params, client_id, secret, Digest::SHA1

  rescue StandardError => e
    # 4a. You should handle an error and render out an appropriate response.
    jsResponse = JsConnect::Response.new 400, "text/plain", e.message
  end
  # To use the jsConnect v2 protocol only use:
  # json = JsConnect.getJsConnectString user, self.params, client_id, secret, secure, Digest::SHA1

  if jsResponse.status == 302
    redirect_to jsResponse.content, :status => jsResponse.status
  else
    response.status = jsResponse.status
    response.content_type = jsResponse.content_type
    render :js => jsResponse.content
  end
end
```

### Configuring Vanilla

Once you've made your authentication page you will need to add that URL to your jsConnect settings in Vanilla's dashboard. This is the **authentication URL**.