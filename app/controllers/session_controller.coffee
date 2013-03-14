mediator = require 'mediator'
Controller = require 'controllers/base/controller'
User = require 'models/user'
LoginView = require 'views/login_view'

module.exports = class SessionController extends Controller

  initialize: ->
    @subscribeEvent 'logout', @logout
    @subscribeEvent 'login:successful', @getSession
    @subscribeEvent 'login', @setupAjaxAuth
    @subscribeEvent 'login', @removeLoginView
    @getSession()

  getSession: ->
    if mediator.storage.has 'accessToken'
      @setupAjaxAuth()
      @publishLogin()  
    else
      mediator.publish 'guest_user'
      @requestLogin()

  requestLogin: ->
    @view = new LoginView

  publishLogin: ->
    mediator.publish 'login', mediator.user

  logout: ->
    @disposeUser()

  disposeUser: ->
    return unless mediator.user
    mediator.storage.removeToken()
    mediator.user.dispose()
    mediator.user = new User

  setupAjaxAuth: ->
    $.ajaxSetup
      headers:
        'X-AUTH-TOKEN': mediator.storage.getToken()

  removeLoginView: ->
    unless !@view then @view.dispose()
