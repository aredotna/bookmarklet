View = require 'views/base/view'
template = require 'templates/link'
mediator = require 'mediator'

module.exports = class LinkView extends View
  template: template
  tagName: 'li'

  initialize: (options)->
    @subscribeEvent 'sidebar:filter', @setValue
    @delegate 'click', '.area', @activateLink
    super

  setValue: (data)->
    if @model?.has('action')
      @model.set('value', data.value) 
      @render()

  activateLink: (e) ->
    if @model?.has('action')
      e.preventDefault()
      e.stopPropagation()
      mediator.publish "action:#{@model.get('action')}", {status: @model.get('params'), title: @model.get('value')}
    else 
      mediator.publish "channel:activate", @model

    $('.highlight').removeClass 'highlight'
    @$el.addClass('highlight')
    false

  afterRender: ->
    super
    @_hideActions()

  _hideActions: ->
    if @model?.has('action')
      @$el.hide()
