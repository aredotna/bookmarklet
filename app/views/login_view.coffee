View = require 'views/base/view'
template = require 'templates/login'
config = require 'config'
mediator = require 'mediator'

module.exports = class LoginView extends View
  template: template
  autoRender: true

  events: 
    "click input[type=submit]" : "submitLogin"
    "keypress" : "checkForSubmit"

  checkForSubmit: (e)->
    if e.keycode is 13
      @login()
      false

  submitLogin: (e) ->
    
    $.ajax
      type: 'POST'
      url: "#{config.api.versionRoot}/tokens"
      data:
        email: @$('#session_email').val()
        password: @$('#session_password').val()
      success: (data) ->
        mediator.storage.setToken data.token
        mediator.publish 'login:successful'
      error: -> mediator.publish 'login:failure'
    false

