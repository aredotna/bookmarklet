config = 
  api: {}
  client: {}
  pusher: {}

production             = yes  
config.env             = if production then 'production' else 'development'
config.api.root        = if production then 'http://api.are.na/' else 'http://localhost:3000/'
config.api.versionRoot = "#{config.api.root}api/v2"
config.client.root     = if production then 'http://54.243.223.202/' else 'http://localhost:3333/'
config.pusher.key      = if production then '19beda1f7e2ca403abab' else '944c5f601f3a394785f0'

module.exports = config