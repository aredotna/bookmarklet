Model = require 'models/base/model'
mediator = require 'mediator'
config = require 'config'

module.exports = class Item extends Model

  defaults:
    percent: 0

  setURL: ->
    channelslug = mediator.channel.get('slug')

    @set
      url:"#{config.client.root}#{channelslug}/show/#{@id}"
      percent: 100