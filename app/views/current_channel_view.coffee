LinkView = require 'views/link_view'

module.exports = class CurrentChannelView extends LinkView
  container: '.currentchannel-container'
  autoRender: yes

  initialize: ->
    super
    @model?.set('is_in_use', true)

  activateLink: ->
    false
