const dgram = require('dgram');
const fs = require('fs');

const port = process.env.PORT || 4242;
const ip = process.env.IP_ADDRESS || '0.0.0.0';

var server = dgram.createSocket('udp4');

server.on('error', (error) => {
	console.log(error);
});

server.on('listening', () => {
	console.log(`Server runned on port ${port}`);
});

server.on('message', (message, remote) => {
    console.log(`${remote.address}:${remote.port} - ${message}`);
		fs.appendFile(`${__dirname}/chat.txt`, `${message}\n`, (error) => {
    	if (error)
			{
        	console.log(error);
					return;
			}
			fs.readFile(`${__dirname}/chat.txt`, 'utf8', (error, contents) => {
				if (error)
				{
					console.log(error);
					return;
				}
				server.send(`${contents.length}`, remote.port, remote.address);
				server.send(contents, remote.port, remote.address);
			});
		});
});

server.bind(port, ip);
