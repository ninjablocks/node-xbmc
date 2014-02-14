{defer} = require 'node-promise'
{EventEmitter} = require 'events'
debug = require('debug') 'xbmc:XbmcApi'
pubsub = require './PubSub'

class XbmcApi extends EventEmitter
  constructor: (@options = {}) ->
    debug 'constructor'
    @queue = []
    @connection = null
    @pubsub = pubsub

    do @loadModules

    @.on 'connection:open', =>
      unless @options.silent
        @message 'Attached to XBMC instance.'
    @.on 'connection:data', (data) =>
      if data.method?
        @notifications.delegate data

    @setConnection @options.connection if @options.connection?

  emit: (evt, data) =>
    debug 'emit', evt, data
    super evt, data, @
    @pubsub.emit evt, data, @

  loadModules: =>
    debug 'loadModules'
    require(module).mixin @ for module in [
      './Media'
      './Notifications'
      './Handlers'
      './Player'
      './Input'
      ]

  setConnection: (newConnection) =>
    debug 'setConnection'
    if @connection
      @connection.api = null
      @connection.close() 
    @connection = newConnection
    @connection.api = @
    @queue.forEach (item) -> @send item.method, item.params, item.dfd
    @queue = []
    do @initialize

  initialize: =>
    debug 'initialize'
    obj = @send 'Player.GetActivePlayers'
    obj.then @handlers.players

  send: (method, params = {}, dfd = null) =>
    debug 'send', method, JSON.stringify params
    data =
      method: method
      params: params
    unless @connection
      data.dfd = defer()
      @queue.push data
      return data.dfd.promise
    connDfd = @connection.send data
    connDfd.pipe dfd.resolve if dfd
    return connDfd

  scrub: (data) ->
    debug 'scrub', data
    data.thumbnail = decodeURIComponent data.thumbnail.replace(/^image:\/\/|\/$/ig, '') if data.thumbnail
    return data

  message: (message = '', title = null, displayTime = 6000, image = null) =>
    debug 'message', message, title, displayTime, image
    title ?= @options.agent || 'node-xbmc'
    options =
      message:     message
      title:       title
      displaytime: displayTime
    options.image = image if image
    @send 'GUI.ShowNotification', options

  connect: =>
    debug 'connection'
    if @connection
      @connection.close() if @connection.isActive()
      @connection.create()

  disconnect: (fn = null) =>
    debug 'disconnect'
    return @connection.close fn if @connection?.isActive()
    do fn if fn

module.exports = XbmcApi
