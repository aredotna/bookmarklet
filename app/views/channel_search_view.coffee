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
    @delegate "keyup", "#channel-picker", @keyup

  keyup: (e)->
    if _.include [38, 40], e.keyCode
      @setHighlight(e)
    else if e.keyCode is 13
      @setItemFromEnter(e)
    else
      @search(e)

  setHighlight: (e) ->
    $visible = @$('li:visible')
    highlighted = @$('li:visible.highlight')
    highlighted.removeClass('highlight')
    if highlighted[0]
      startEl = highlighted[0]
      index = @$("li:visible").index(startEl)
      length = $visible.length
      if e.keyCode is 40
        nextindex = if (index+1) > (length-1) then 0 else index+1
      else if e.keyCode is 38 
        nextindex = if (index-1) < 0 then length-1 else index-1

      next = $visible[nextindex]
    else
      next = $visible[0]

    $(next).addClass('highlight')
    @scrollCheck()

  setItemFromEnter: (e)->
    item = @$('.highlight').find('.sidebar-item')
    id = item.data('id')
    model = @collection.get(id)
    if model
      view = @viewsByCid[model.cid]
      view.activateLink(e)


  scrollCheck: ->
    listScroll = @$('.typeahead').scrollTop()
    listHeight = @$('.typeahead').height()
    itemHeight = @$('li.highlight').height()
    itemTop = @$('li.highlight').position().top
    @$('.typeahead').scrollTop(itemTop + itemHeight - listHeight + listScroll)

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
