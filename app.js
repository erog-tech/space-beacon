const http = require('http');

const requestListener = function (req, res) {
  res.writeHead(200);
  res.end('Greetings from the DevOps Squadron!');
}

const server = http.createServer(requestListener);
server.listen(80);
