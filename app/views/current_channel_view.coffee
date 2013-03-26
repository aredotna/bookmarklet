LinkView = require 'views/link_view'
linkTemplate = require 'templates/link'

module.exports = class CurrentChannelView extends LinkView
  container: '.current-channel-container'
  autoRender: yes

  initialize: ->
    super
    @model?.set('is_in_use', true)

  activateLink: ->
    false

  render: ->
    return unless @model
    super