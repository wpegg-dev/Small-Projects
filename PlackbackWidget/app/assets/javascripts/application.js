// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$(document).ready(function(){  
	//$( "#restartDialog" ).dialog({
	//    autoOpen: false
	//  });
	
	var sound = new Audio('/assets/Uptown_Funk.m4a');
	
	sound
		.isPlayed = false
		.volume = 1;
	
	
	$('#butt').on('click',function(){
		//alert("button clicked");
		if (!sound.isPlayed) {
			sound.play(); // Play sound
			$(this)
				.removeClass('btn-warning glyphicon-play')//.removeClass('btn-succes glyphicon-play')
				.addClass('btn-info glyphicon-pause');//.addClass('btn-danger glyphicon-pause');
		} else {
			sound.pause(); // Pause sound
			$(this)
				.removeClass('btn-info glyphicon-pause')//.removeClass('btn-danger glyphicon-pause')
				.addClass('btn-warning glyphicon-play');//.addClass('btn-success glyphicon-play');
		}
		sound.isPlayed = !sound.isPlayed;
	});
	
	$('#vol-value').css({'width': sound.volume * 100 + "%"});
	$('#vol-dec').on('click', function(){
		sound.volume -= 0.05;
		$('#vol-value').css({'width': sound.volume * 100 + "%"});
	});
	
	
	$('#vol-inc').on('click', function(){
		sound.volume += 0.05;
		$('#vol-value').css({'width': sound.volume * 100 + "%"});
	});
	
	var audioElement = sound; 
	audioElement.addEventListener('play', draw);
	
	var context = new AudioContext(),
			analyser = context.createAnalyser(),
			source,
			bars = [];
	
	window.onload = function() {
		source = context.createMediaElementSource(audioElement);
	
		source.connect(analyser);
		analyser.connect(context.destination);
	
		prepareElements();
	};
	
	function prepareElements() {
		var el = document.getElementById("spectrum"),
				width = 20;
	
		for (var i=0; i<50; i++) {
			var bar = document.createElement("div");
			bar.style.left = (width + 5) * i + "px";
			el.appendChild(bar);
			bars.push(bar);
		}
	}
	
	function draw() {
		requestAnimationFrame(draw);
	
		var freqData = new Uint8Array(analyser.frequencyBinCount);
			analyser.getByteFrequencyData(freqData);
	
		for (var i=0; i<bars.length; i++) {
			var freq = Math.round(i*freqData.length/bars.length);
			bars[i].style.height = freqData[freq]+"px";
		}
	}
});

