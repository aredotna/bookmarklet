mediator = require 'mediator'
Controller = require 'controllers/base/controller'
User = require 'models/user'

module.exports = class SessionController extends Controller

  initialize: ->
    @subscribeEvent 'logout', @logout
    @subscribeEvent 'login:successful', @getSession
    @subscribeEvent 'login:successful', @redirectHome
    @subscribeEvent 'login', @setupAjaxAuth

    @getSession()

  getSession: ->
    if mediator.storage.has 'accessToken'
      @setupAjaxAuth()
      mediator.user.fetch
        success: (model, response) => @publishLogin()
    else
      mediator.publish 'guest_user'

  publishLogin: ->
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
