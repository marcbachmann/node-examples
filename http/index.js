//
// Simple http server
//
var http = require('http');
var serve = require('serve-static')('./');
var finalhandler = require('finalhandler');

var server = http.createServer(function(req, res){

  if (req.method == 'GET' && req.url == '/test') {
    res.writeHead('Content-Type', 'application/json');
    res.write(JSON.stringify({foo: 'bar'}, null, 2));
    return res.end();
  }

  var notFound = finalhandler(req, res);
  serve(req, res, notFound);
});

server.listen(0, function(){
  var port = server.address().port;
  console.log("Static server listening on http://localhost:%s", port);
  console.log("Example response http://localhost:%s/test", port);
  console.log("Example file http://localhost:%s/package.json", port);
});
