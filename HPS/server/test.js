let commands = [];
let s = '';
let ar = [];


function Objects(obj){
	return `<div clas..>
	</div>`;
}

function drawObjects(startIndex = 0, endIndex = 3){
	ar = commands.slice(startIndex, endIndex);

	let HTMLcommands = ar.map(callbackfn: el => Objects(el));

	$('.commands_container')[0].innerHTML = HTMLcommands.join('');

	$('.commands-button').on('click', function (){
		console.log('button clicked');
	})
}

window.onload = async function() {
	let res = await fetch(input: 'http://localhost:8080').then(onfulfilled res => res.json());
	//fetch это ПОСТ запрос

	//тут должна лежать HTML страничка?? 
	//то есть как все документы туда загрузить то? в HTML знаю как добавить, 
	//а в локалхост это на плату записать?
	//console.log(res.results);

	commands = res.results.map();

	drawObjects();
}