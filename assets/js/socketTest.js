var socket = io.connect('http://localhost:3000');
socket.on('newFrame', function(data) {
	updateTable(data);
});

function updateTable(leds) {
	var tableBody = $('table.led-table tbody')
	for (var i = 0; i < leds.length; i++) {
		for (var j = 0; j < leds[i].length; j++) {
			var tdElement = $(tableBody.children('tr')[i]).children('td')[j];
			var inputElement = $(tdElement).children('input')		
			inputElement.val(leds[i][j]);
		}
	}
}


$('body').keypress(function(event) {
	
	console.log(event);

	var charCode = event.charCode;
	var key = 'up';

	if (charCode === 119)
		key = 'up';
	else if (charCode === 97)
		key = 'left';
	else if (charCode === 115)
		key = 'down';
	else if (charCode === 100)
		key = 'right';

	console.log(key);
	socket.emit('keypress', key);
});

/**
$('.led').on("change", function(event) {
	var listItem = $(this);
	var colorInput = $(this).children('input');
	handleLEDClick(listItem.data('index'), colorInput.val());
	handleInput();
});
*/


function handleLEDClick(index, color) {
	socket.emit('ledChange', { 
		index: index,
		color: color       
	});
}

function handleInput() {
	socket.emit('input', {
		key: 56
	});
}
