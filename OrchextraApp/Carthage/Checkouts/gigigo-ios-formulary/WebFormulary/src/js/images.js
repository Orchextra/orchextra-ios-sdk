window.getHtmlImageMandatory = function getHtmlImageMandatory() {
	return '<div class="imagesZone"><p>Imagen obligatorio:</p><input id="imageMandatory"type="text"name="element"></div>';
}

window.getHtmlAllImage = function getHtmlAllImage() {
	return '<div class="imagesZone"><p>Imagen obligatorio:</p><input id="imageMandatory"type="text"name="element"><p>Imagen checkBox On:</p><input id="imageCheckBoxOn"type="text"name="element"><p>Imagen checkBox Off:</p><input id="imageCheckBoxOff"type="text"name="element"></div>';
}

window.recoverHtmlImageMandatory = function recoverHtmlImageMandatory(imageMandatory) {

    var htmlImage =  '<div class="imagesZone withOutStyle2"><p>Sin estilo de imagenes</p></div>';
    if (imageMandatory != "") {
		htmlImage = '<div class="imagesZone"><p>Imagen obligatorio:</p><input id="imageMandatory"type="text"name="element" disabled readonly value="'+imageMandatory+'"></div>';
	}

	return htmlImage
}

window.recoverHtmlAllImage = function recoverHtmlAllImage(imageMandatory,imageCheckBoxOn,imageCheckBoxOff) {

    var htmlImage =  '<div class="imagesZone withOutStyle2"><p>Sin estilo de imagenes</p></div>';
    if (imageMandatory != "" || imageCheckBoxOn != "" || imageCheckBoxOff != "") {
		htmlImage = '<div class="imagesZone"><p>Imagen obligatorio:</p><input id="imageMandatory"type="text"name="element" disabled readonly value="'+imageMandatory+'"><p>Imagen checkBox On:</p><input id="imageCheckBoxOn"type="text"name="element" disabled readonly value="'+imageCheckBoxOn+'"><p>Imagen checkBox Off:</p><input id="imageCheckBoxOff"type="text"name="element" disabled readonly value="'+imageCheckBoxOff+'"></div>';
	}

	return htmlImage
}



