// Generated by CoffeeScript 1.3.3
(function() {
  var TCPConnection, XbmcApi, config, connection, file, xbmcApi, _ref;

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

  file = process.argv[2] || '/media/movies/movie1.avi';

  xbmcApi.player.openFile(file);

}).call(this);
