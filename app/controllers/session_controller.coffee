mediator = require 'mediator'
Controller = require 'controllers/base/controller'
User = require 'models/user'
LoginView = require 'views/login_view'
config = require 'config'

module.exports = class SessionController extends Controller

  initialize: ->
    @subscribeEvent 'login', @onLogin
    
    @checkSession()

  checkSession: ->
    mediator.user.validateSession (isValid)=>
      if isValid
        mediator.publish 'login', mediator.user
      else
        @requestLogin()

  requestLogin: ->
    @view = new LoginView

  onLogin: ->
    @setupAjaxAuth()
    @removeLoginView()

  setupAjaxAuth: ->
    $.ajaxSetup
      headers:
        'X-AUTH-TOKEN': mediator.storage.getToken()

  removeLoginView: ->
    @view?.dispose()
