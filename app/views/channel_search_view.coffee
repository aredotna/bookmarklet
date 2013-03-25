CollectionView = require 'views/base/collection_view'
LinkView = require 'views/link_view'
Channel = require 'models/channel'
mediator = require 'mediator'
config = require 'config'


module.exports = class ChannelSearchView extends CollectionView
  
  container: ".channelsearch-container"
  listSelector: '.dropdown-menu'
  animationDuration: 0

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
    query = $.trim $('#channel-picker').val()
    if query.length
      @currentRequest?.abort()
      @startLoad()
      @currentRequest = $.get config.api.versionRoot + '/search/channels?per=3&q=' + query, (data) =>
        @endLoad()
        @processSearchResults(data)
    else
      @$list.hide()

  processSearchResults: (data)->
    @collection.reset(data.channels)

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
    mediator.storage.setItem "currentChannel", JSON.stringify(e.toJSON())
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

  startLoad: ->
    @$('.search-query').addClass('loading')

  endLoad: ->
    @$('.search-query').removeClass('loading')