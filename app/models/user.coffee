ChannelCollection = require 'models/channel_collection'
Channel = require 'models/channel'
Model = require 'models/base/model'
mediator = require 'mediator'
config = require 'config'

module.exports = class User extends Model

  url: "#{config.api.versionRoot}/accounts"

  initialize: ->
    super

  setLinks: ->
    links = new ChannelCollection(@actionLinks())
    links.add @get('channels')
    @set 'links', links

  actionLinks: ->
    actions = []

    search = new Channel
      title: 'Search for '
      visible: false
      action: 'search'
      params: ''
      value: ''
      sorter: 1
      meta: 'or press Enter'
      class: 'link-search sidebar-item-action'
      id: 'link-search'

    public_channel = new Channel
      title: 'Create a public channel called '
      visible: false
      action: 'newChannel'
      params: 'public'
      value: ''
      sorter: 2
      meta: 'or press Alt+Enter'
      class: 'link-create-public sidebar-item-action'
      id: 'link-create-public'

    private_channel = new Channel
      title: 'Create a private channel called '
      visible: false
      action: 'newChannel'
      params: 'private'
      value: ''
      sorter: 3
      meta: 'or press Alt+Shift+Enter'
      class: 'link-create-private sidebar-item-action'
      id: 'link-create-private'

    actions.push public_channel, private_channel

    return actions
