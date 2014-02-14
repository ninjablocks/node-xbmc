// Generated by CoffeeScript 1.3.3
(function() {
  var TCPConnection, XbmcApi, config, connection, id, xbmcApi, _ref;

  _ref = require('..'), TCPConnection = _ref.TCPConnection, XbmcApi = _ref.XbmcApi;

  config = require('./config');

  connection = new TCPConnection({
    host: config.connection.host,
    port: config.connection.port,
    verbose: false
  });

  xbmcApi = new XbmcApi({
    silent: true,
    connection: connection
  });

  id = process.argv[2] || 'QH2-TGUlwu4';

  xbmcApi.player.openYoutube(id);

}).call(this);
