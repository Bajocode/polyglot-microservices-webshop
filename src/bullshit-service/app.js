const http = require('http');
const url = require('url');
const Config = require('./config');
const config = new Config();

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');

  if (req.url.startsWith('/rev') && req.method === 'GET') {
    const query = url.parse(req.url, true).query.q;
    res.end(reversed(query));
  } else if (req.url === '/bullshit' && req.method === 'GET') {
    res.end('BULLSHIT');
  } else {
    res.end('NORMALSHIT');
  }
});

function reversed(s) {
  const arr = s.split('');
  let l = 0, r = s.length-1;
  while (l < r) {
    [arr[l], arr[r]] = [arr[r], arr[l]];
    l += 1;
    r -= 1;
  }
  return arr.join('');
}

server.listen(config.serverPort, config.serverHost, () => {
  console.log(`Server running at http://${config.serverHost}:${config.serverPort}/`);
});

exports.reversed = reversed;
