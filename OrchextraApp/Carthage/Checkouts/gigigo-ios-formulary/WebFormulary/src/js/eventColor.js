

window.cellColorEvent;
window.titleColorEvent;
window.errorColorEvent;
window.aceptColorEvent;
window.containerAceptColorEvent;
window.backgroundPickerColorEvent;

window.launchEventColors = function launchEventColors() {
	cellColorEvent = document.getElementById("cellColor");
	titleColorEvent = document.getElementById("titleColor");
	errorColorEvent = document.getElementById("errorColor");
	aceptColorEvent = document.getElementById("aceptColor");
	containerAceptColorEvent = document.getElementById("containerAceptColor");
	backgroundPickerColorEvent = document.getElementById("backgroundPickerColor");

	if (cellColorEvent) {
		cellColorEvent.addEventListener("input", function() {
	    	$("#cellColorHex").val(cellColorEvent.value)
		}, false);
	}

	if (cellColorEvent) {
		titleColorEvent.addEventListener("input", function() {
		    $("#titleColorHex").val(titleColorEvent.value)
		}, false);
	}

	if (cellColorEvent) {
		errorColorEvent.addEventListener("input", function() {
		    $("#errorColorHex").val(errorColorEvent.value)
		}, false);
	}

	if (aceptColorEvent) {
		aceptColorEvent.addEventListener("input", function() {
		    $("#aceptColorHex").val(aceptColorEvent.value)
		}, false);
	}

	if (containerAceptColorEvent) {
		containerAceptColorEvent.addEventListener("input", function() {
		    $("#containerAceptColorHex").val(containerAceptColorEvent.value)
		}, false);
	}

	if (backgroundPickerColorEvent) {
		backgroundPickerColorEvent.addEventListener("input", function() {
		    $("#backgroundPickerColorHex").val(backgroundPickerColorEvent.value)
		}, false);
	}	
}