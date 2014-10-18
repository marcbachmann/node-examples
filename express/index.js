//
// Simple http server using express
//
var express = require('express');
var app = express();

app.get('/test', function(req, res) {
  res.json({foo: 'bar'});
});

app.use(express.static('./'));

var server = app.listen(0, function(){
  var port = server.address().port;
  console.log("Static server listening on http://localhost:%s", port);
  console.log("Example response http://localhost:%s/test", port);
  console.log("Example file http://localhost:%s/package.json", port);
});
