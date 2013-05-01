Chaplin = require 'chaplin'
mediator = require 'mediator'
routes = require 'routes'
SessionController = require 'controllers/session_controller'
BookmarkletController = require 'controllers/bookmarklet_controller'
Storage = require 'models/storage'
Metrics = require 'models/metrics'
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

    @initMetrics()

    @propagateEvents()
    mediator.on 'location', @setSource
    mediator.on 'message:send', @sendMessage

    @ready()

  setSource: (data)->
    mediator.source = 
      url: data.value.url
      title: data.value.title

  initLayout: ->
    @layout = new Layout {@title}

  initMediator: ->
    Chaplin.mediator.user = new User
    Chaplin.mediator.channel = null
    Chaplin.mediator.storage = new Storage
    Chaplin.mediator.source = {}
    Chaplin.mediator.seal()

  initControllers: ->
    new BookmarkletController()
    new SessionController()

  propagateEvents: ->
    window.addEventListener 'message', (e) ->
      if e.data isnt 'close'
        mediator.publish(e.data.action, e.data)

  sendMessage: (data)->
    window.top.postMessage(data, '*')

  ready: ->
    @sendMessage action: 'bookmarklet:ready'

  initMetrics: ->
    @metrics = new Metrics
