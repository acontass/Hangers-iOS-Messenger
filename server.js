const net = require('net');
const fs = require('fs');

var server = net.createServer(function(socket) {
	console.log('Client connected');

	socket.on('data', function(data) {
		console.log(data.toString());
		fs.appendFile(`${__dirname}/chat.txt`, data.toString() + '\n', function(err) {
    	if(err)
        	return console.log(err);
			fs.readFile(`${__dirname}/chat.txt`, 'utf8', function(err, contents) {
				if (err)
					return
				socket.write(contents);
			});
		});
	});

	socket.on('error', function(error) {
		console.log(error);
	});
});

server.on('listening', function() {
	console.log('Server runned on port 4242');
})

server.listen(4242, '0.0.0.0');
