View = require 'views/base/view'
template = require 'templates/login'
config = require 'config'
mediator = require 'mediator'

module.exports = class LoginView extends View
  template: template
  autoRender: true
  container: '.login-container'
  attributes:
    id: "login"

  events: 
    "click input[type=submit]" : "submitLogin"
    "keypress" : "checkForSubmit"
    "click .close-marklet": "closeWindow"

  checkForSubmit: (e)->
    if e.keycode is 13
      @login()
      false

  submitLogin: (e) ->
    $.ajax
      type: 'POST'
      url: "#{config.api.versionRoot}/tokens"
      dataType: "json"
      data:
        email: @$('#session_email').val()
        password: @$('#session_password').val()
      success: (data) ->
        mediator.storage.setToken data.token
        mediator.publish 'login'
      error: -> 
        mediator.publish 'login:failure'
    false

  closeWindow: (e) ->
    mediator.publish 'message:send', action: "close"
