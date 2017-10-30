
window.getFontPositionZone= function getFontPositionZone() {
    var htmlListFont = createListOptionsFont();
	return '<div class="fontPositionZone"> <p>Alineacion:</p><select id="selectTypeAlign"> <option value="">Por defecto</option> <option value="alignLeft">Izquierda</option> <option value="alignCenter">Centrado</option> <option value="alignRight">Derecha</option> </select> <p>Tipo de Fuente:</p><select id="selectTypeFont"> '+htmlListFont+' </select> <input id="custonFont" placeHolder="Nombre fuente personalizada"> </div>';
}

window.createListOptionsFont = function createListOptionsFont() {
    var htmlListFont = '<option value="">Por defecto</option><option value="custom">Personalizada</option>';
    var arrayListFonts = listFonts.split(","); 

    for (var i = 0; i < arrayListFonts.length; i++) {
        htmlListFont +='<option value="'+arrayListFonts[i]+'">'+arrayListFonts[i]+'</option>';                    
    }
    return htmlListFont;
}
