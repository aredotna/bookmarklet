mediator = require 'mediator'
Controller = require 'controllers/base/controller'
User = require 'models/user'
LoginView = require 'views/login_view'

module.exports = class SessionController extends Controller

  initialize: ->
    @subscribeEvent 'logout', @logout
    @subscribeEvent 'login:successful', @getSession
    @subscribeEvent 'login:successful', @redirectHome
    @subscribeEvent 'login', @setupAjaxAuth
    @subscribeEvent 'login', @removeLoginView
    @getSession()

  getSession: ->
    if mediator.storage.has 'accessToken'
      @setupAjaxAuth()
      mediator.user.fetch
        success: (user, response) => 
          user.setLinks()
          @publishLogin()
    else
      mediator.publish 'guest_user'
      @requestLogin()

  requestLogin: ->
    @view = new LoginView
      container: $('.bookmarklet-content')

  publishLogin: ->
    console.log 'logged in', mediator.user
    mediator.publish 'login', mediator.user

  redirectHome: ->
    @redirectTo "/"

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
