Chaplin = require 'chaplin'
mediator = require 'mediator'
routes = require 'routes'
SessionController = require 'controllers/session_controller'
Storage = require 'models/storage'
Layout = require 'views/layout'
User = require 'models/user'

module.exports = class Application extends Chaplin.Application
  title: 'Arena Bookmarklet'

  initialize: ->
    super

    @initDispatcher()
    @initLayout()
    @initMediator()

    @initControllers()
    @initRouter routes
    Object.freeze? this

    @propagateEvents()
    mediator.on 'location', @setLocation
    mediator.on  'message:send', @sendMessage

    @ready()

  setLocation: (location)->
    mediator.pageUrl = location.href

  initLayout: ->
    @layout = new Layout {@title}

  initMediator: ->
    Chaplin.mediator.user = new User
    Chaplin.mediator.channel = null
    Chaplin.mediator.storage = new Storage
    Chaplin.mediator.pageUrl = ''
    Chaplin.mediator.seal()

  initControllers: ->
    new SessionController()

  propagateEvents: ->
    window.addEventListener 'message', (e) ->
      if e.data isnt 'close'
        mediator.publish(e.data.action, e.data)

  sendMessage: (data)->
    window.top.postMessage(data, '*')

  ready: ->
    @sendMessage action: 'bookmarklet:ready'
