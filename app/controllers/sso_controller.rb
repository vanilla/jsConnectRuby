require "js_connect"

class SsoController < ApplicationController
  def index
    # 1. Get your client ID and secret here. These must match those in your jsConnect settings.
    client_id = "12345"
    secret = "1234"

    # 2. Grab the current user from your session management system or database here.
    signedIn = true # this is just a placeholder

    # YOUR CODE HERE.

    # 3. Fill in the user information in a way that Vanilla can understand.
    user = {}

    if signedIn
       # CHANGE THESE FOUR LINES.
       user["uniqueid"] = "234"
       user["name"] = "John Ruby"
       user["email"] = "john.ruby@anonymous.com"
       user["photourl"] = ""
    end

    # 4. Generate the jsConnect string.
    secure = true # this should be true unless you are testing.
    json = JsConnect.getJsConnectString(user, self.params, client_id, secret, secure)
    
    render :text => json
  end

end
