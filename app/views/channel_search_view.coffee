CollectionView = require 'views/base/collection_view'
LinkView = require 'views/link_view'
Channel = require 'models/channel'
template = require 'templates/search'
mediator = require 'mediator'

module.exports = class ChannelSearchView extends CollectionView
  
  container: ".channelsearch-container"
  template: template
  listSelector: '.dropdown-menu'

  initialize: (options)->
    super
    @subscribeEvent "channel:activate", @setChannel
    @subscribeEvent "click", @hideSearch
    @delegate "click", "#channel-picker", @showUnlessEmpty
    @delegate "keyup", "#channel-picker", @search

  search: (e)->
    query = $('#channel-picker').val()
    if query.length > 0
      mediator.publish 'sidebar:filter', value: query
      @applyFilter value: query
      if @visibleItems.length
        @$list.show()
        $(window).bind 'click', @hideSearch
      else 
        @$list.hide()

  showUnlessEmpty: ->
    unless $('#channel-picker').val() is ''
      @search()
      false

  hideSearch: =>
    $(window).unbind 'click', @hideSearch
    @$list.hide()

  setChannel: (e)->
    mediator.channel = e
    mediator.storage.setItem "currentChannel", e.get('title')
    @$list.hide()
    mediator.publish('channel:change')
    false

  setCurrentItem: ->
    curItem = this.collection.where({slug:mediator.channel?.model?.id})[0]
    curItem?.set('is_in_use', true)

  getView: (channel)->
    new LinkView model: channel

  afterRender: ->
    super
    @$('#channel-picker').focus()

  applyFilter: (options) -> 
    @filter (model, position) -> 
      if options.value is ""
        if model.has('action') then false else true
      else
        pattern = new RegExp(options.value, "gi")
        value = if model.has('username') then model.get('username') else model.get('title')
        pattern.test(value) or model.has('action')

  activateLink: (e) ->
    if @model.has('action')
      e.preventDefault()
      e.stopPropagation()
      mediator.publish "action:#{@model.get('action')}", {status: @model.get('params'), title: @model.get('value')}

    $('li:visible.highlight').removeClass 'highlight'
    @$el.addClass('highlight')
