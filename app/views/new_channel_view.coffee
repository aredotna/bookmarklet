View     = require "views/base/view"
Channel  = require "models/channel"
template = require "templates/new_channel"
mediator = require "mediator"

module.exports = class NewChannelView extends View
  template: template
  autoRender: true

  initialize: ->
    @_resetModel()
    super

    @on 'addedToDOM', =>
      $('.tooltip').empty()
      @delegate "click", ".new-channel-form-toggle", @toggleNewChannelForm
      @delegate "click", ".panel-close", @toggleNewChannelForm
      @delegate "click", "input[type=submit]", @createChannel
      @delegate "click", ".channel-status", @changeStatus
      @delegate "keyup", ".channel-name", @updateTitle
      @delegate "keypress", @maybeCreateChannel

  afterRender: ->
    super
    
    if @isVisible
      @showCreateInterface()

  showCreateInterface: ->
    @isVisible = true
    @$("#new-channel-container").addClass("active")
    @$("#new-channel-form").removeClass("hide")
    false

  hideCreateInterface: ->
    @isVisible = false
    @$("#new-channel-container").removeClass("active")
    @$("#new-channel-form").addClass("hide")
    false

  maybeCreateChannel: (e) ->
    if e.keyCode is 13
      e.preventDefault()
      @createChannel(e)

  createChannel: (e) ->
    e.preventDefault()

    return unless @validate()

    attributes = 
      title: @getTitle()
      status: @getStatus()

    channel = new Channel attributes
    channel.save null,
      success: (model) =>
        model.set("is_in_use", true)
        mediator.publish "shortcut:activate", "userChannels"
        @hideCreateInterface()

      error: ->
        mediator.publish "error"

  validate: ->
    valid = $.trim(@model.get("title")) isnt ""
    @highlightErrors() unless valid
    return valid

  highlightErrors: ->
    @$(".channel-name").addClass("invalid")

  toggleIsVisible: ->
    if @isVisible is true
      @isVisible = false
    else
      @isVisible = true

  toggleNewChannelForm: (e) ->
    e.preventDefault()

    @toggleIsVisible()

    @$(".channel-name").focus()
    $("#new-channel-container").toggleClass("active")
    @$("#new-channel-form").toggleClass("hide")

  changeStatus: (e) ->
    e.preventDefault()
    data = status: $(e.currentTarget).data "channel-status"
    @model.set(data)
    @render()

  getTitle: ->
    @$("input[name=channel_name]").val()

  getStatus: ->
    @$("#state-indicator strong").attr("class")

  updateTitle: =>
    @model.set title: @getTitle()

  _resetModel: ->
    @model = new Channel
      status: "closed"
      user_id: mediator.user.id
      permissions: ["edit"]
      class: "Channel"

  dispose: ->
    super
