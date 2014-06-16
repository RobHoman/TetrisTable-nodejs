var socket = io.connect('http://localhost');
socket.on('news', function(data) {
	console.log(data);
	socket.emit('my other event', { my: 'data' });
});

$('.led').on("click", function(event) {
	handleLEDClick($(this));
});

function handleLEDClick(listItem) {
	var index = listItem.data('index');
	socket.emit('led', { index: index });
}
