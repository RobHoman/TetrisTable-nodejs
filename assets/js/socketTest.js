var socket = io.connect('http://192.168.0.35');
socket.on('news', function(data) {
	console.log(data);
	socket.emit('my other event', { my: 'data' });
});

$('.led').on("change", function(event) {
	var listItem = $(this);
	var colorInput = $(this).children('input');
	handleLEDClick(listItem.data('index'), colorInput.val());
});

function handleLEDClick(index, color) {
	socket.emit('ledChange', { 
		index: index,
		color: color       
	});
}
