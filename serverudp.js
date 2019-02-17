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
    	if (error) {
        	console.log(error);
					return;
			}
			fs.readFile(`${__dirname}/chat.txt`, 'utf8', (error, contents) => {
				if (error) {
					console.log(error);
					return;
				}
//				console.log(contents.length);
//				console.log(contents);
				var client = dgram.createSocket('udp4');
				client.send(`${contents.length}`, 0, `${contents.length}`.length, 4243, remote.address, function(err, bytes) {
					if (error) {
						console.log(error);
						return;
					}
				    console.log(`UDP file contents lenght (${contents.length} bytes) sent to ` + remote.address +':'+ 4243);
						client.send(contents, 0, contents.length, 4243, remote.address, function(err, bytes) {
						    if (err) throw err;
						    console.log('UDP file contents sent to ' + remote.address +':'+ 4243);
						    client.close();
						});
				});
			});
		});
});

server.bind(port, ip);
