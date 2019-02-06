const net = require('net');
const fs = require('fs');

const port = process.env.PORT || 4242;
const ip = process.env.IP_ADDRESS || '0.0.0.0';

var server = net.createServer((socket) => {
	console.log('Client connected');

	socket.on('data', (data) => {
		console.log(`${socket.remoteAddress}:${socket.remotePort} - ${data.toString()}`);
		fs.appendFile(`${__dirname}/chat.txt`, data.toString() + '\n', (err) => {
    	if (err)
			{
        	console.log(err);
					return;
			}
			fs.readFile(`${__dirname}/chat.txt`, 'utf8', (err, contents) => {
				if (err)
				{
					console.log(err);
					return;
				}
				socket.write(contents);
			});
		});
	});

	socket.on('error', (error) => {
		console.log(error);
	});
});

server.on('error', (error) => {
	console.log(error);
	server.close();
});

server.on('listening', () => {
	console.log(`Server runned on port ${port}`);
});

server.listen(port, ip);
