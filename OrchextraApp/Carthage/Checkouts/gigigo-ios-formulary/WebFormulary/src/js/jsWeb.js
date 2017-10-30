

window.fieldSelected = ""
window.listFieldsResult = []
window.indexField = 0


window.removeField = function removeField(idRemove){
    var auxListFieldsResult = [];
    
    for (var i=0; i<listFieldsResult.length; i++) {
        
        var find = false;
        
        $.each(listFieldsResult[i], function(index, val) {
            if (index == "tag" && val == idRemove){
                find = true;
            }
        });
        
        if (!find) {
            auxListFieldsResult.push(listFieldsResult[i])
        }
    }
    
    listFieldsResult = auxListFieldsResult;
    
    $("#fieldNumber"+idRemove).slideUp();
}
            
window.addField = function addField() {
    if (fieldSelected == "Text") {
        validateTextField();
    }
    else if (fieldSelected == "Picker") {
        validatePickerField();
    }
    else if (fieldSelected == "DatePicker") {
        validateDatePickerField();
    }
    else if (fieldSelected == "Boolean") {
        validateBooleanField();
    }
    else if (fieldSelected == "Index") {
        validateIndexField();
    }
}

window.resetTypeField = function resetTypeField() {
    clearTypeField()
    $(".selectTypeField").val("None");
}

window.clearTypeField = function clearTypeField(){
    $("#createField").slideUp(function(){
           $("#containterElementField").empty()
    });
}

//======================================
//          ADD NEW FILED             //
//======================================

window.createElementField = function createElementField(typeField) {
    $("#containterElementField").empty()
    fieldSelected = typeField;
    var html = '';
    var htmlFont = getFontPositionZone()
    var htmlImage = getHtmlImageMandatory();

    if (typeField == "Text") {
        html = require('html-loader!../aux/auxText.html')
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Picker") {
        idPickerField = 1; // Reset Picker
        html = require('html-loader!../aux/auxPicker.html')
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "DatePicker") {
        html = require('html-loader!../aux/auxDatePicker.html')
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Boolean") {
        htmlImage = getHtmlAllImage();
        html = require('html-loader!../aux/auxBoolean.html')
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Index") {
        html = require('html-loader!../aux/auxIndex.html')
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
    }

    $("#containterElementField").append(html)

    launchEventColors();
    createEventFont();
    createEventTextCompare();
    showContainerCustomValidate();
}

window.createEventFont = function createEventFont() {
     $("#selectTypeFont").change(function() {
         if (this.value == "custom") {
            $("#custonFont").css("display","block");
         }
         else {
            $("#custonFont").css("display","none");
         }
    });
}

window.createEventTextCompare = function createEventTextCompare() {
     $("#compare").change(function() {
         if (this.checked == true) {
            $("#containerCompare").css("display","block");
            $("#compareTextError").css("display","block");
         }
         else {
            $("#containerCompare").css("display","none");
            $("#compareTextError").css("display","none");
         }
    });
}

window.showContainerCustomValidate = function showContainerCustomValidate() {
     $("#selectTypeValidator").change(function() {
         if (this.value == "customValidator") {
            $("#custonValidator").css("display","block");
         }
         else {
            $("#custonValidator").css("display","none");
         }
         if (this.value == "None") {
            $("#validatorTextError").css("display","none");
         }
         else {
            $("#validatorTextError").css("display","block");
         }

         if (this.value == "lengthText") {
            $("#minMaxValidatorContainer").css("display","block");
         }
         else {
            $("#minMaxValidatorContainer").css("display","none");
         }
    });
}

window.syntaxHighlight = function syntaxHighlight(json) {
if (typeof json != 'string') {
    json = JSON.stringify(json, undefined, 2);
}
json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                    var cls = 'number';
                    if (/^"/.test(match)) {
                        if (/:$/.test(match)) {
                        cls = 'key';
                        } else {
                        cls = 'string';
                        }
                        } else if (/true|false/.test(match)) {
                        cls = 'boolean';
                        } else if (/null/.test(match)) {
                        cls = 'null';
                        }
                        return '<span class="' + cls + '">' + match + '</span>';
                        });
 }
                    
                    
                    
window.copiarAlPortapapeles = function copiarAlPortapapeles() {
        var aux = document.createElement("input");
                    
        var recoverJSON = JSON.stringify(listFieldsResult, undefined, 4);
        recoverJSON = '{ \n "fields":'+recoverJSON+' \n}';
                    
        aux.setAttribute("value", recoverJSON);
        document.body.appendChild(aux);
        aux.select();
        document.execCommand("copy");
        document.body.removeChild(aux);
    }




//======================================
//          GENERAR JSON              //
//======================================

                    
window.output = function output(inp) {
     document.body.appendChild(document.createElement('pre')).innerHTML = inp;
}
                 

$(".selectTypeField").change(function() {
     createElementField(this.value)
});             
                    

window.copyList = function copyList(listFields) {
    var copyListFields = JSON.parse(JSON.stringify(listFields));

    for (var i = 0; i < copyListFields.length; i++) {
        var field = copyListFields[i];
        delete field["tag"];
        copyListFields[i] = field;
    }

    return copyListFields;
}

$("#buttonGenerateJson").click(function() {
    $("#containerJsonItemsCreated").empty()
    var copyListField = copyList(listFieldsResult);
    var recoverJSON = JSON.stringify(copyListField, undefined, 4);
    recoverJSON = '{ \n "fields":'+recoverJSON+' \n}';
   $("#containerJsonItemsCreated").append("<button class='btn butonCopyPaste' data-clipboard-action='copy' data-clipboard-target='#bar'>Copiar</button><textarea id='bar'>"+recoverJSON+"</textarea><pre>"+syntaxHighlight(recoverJSON)+"</pre>")
});
 
var idColor = ""           
window.cellColorOpen = function cellColorOpen(idCellColor) {
	idColor = idCellColor;
    $("#ControlColor").show();
}
                    
$("#closeSaveColor").click(function() {
    $("#ControlColor").hide();
    $("#"+idColor).css("background-color", $("#testPatch").text());
    $("#"+idColor).empty()
    $("#"+idColor).append("<p id='colorId'>"+$("#testPatch").text()+"</p>");
});
                    
var clipboard = new Clipboard('.btn');

clipboard.on('success', function(e) {
             console.log("OK");
             console.log(e);
             });

clipboard.on('error', function(e) {
             console.log("OK");
             console.log(e);
             });



//======================================
//               GENERIC              //
//======================================

window.getStyleColor = function getStyleColor(cellColor,titleColor,errorColor) {
    var html = '<div class="colorZone withOutStyle"><p>Sin estilo de color</p><div id="cellColor"></div></div>';
    if (cellColor != "" || titleColor != "" || errorColor != "") {
        html = '<div class="colorZone"><p>Color de la celda:</p><div id="cellColor" class="cellColor" style="background-color:'+cellColor+'"><p id="colorId">'+cellColor+'</p></div><p class="colorTittleP">Color titulo:</p><div id="titleColor" class="cellColor" style="background-color:'+titleColor+'"><p id="colorId">'+titleColor+'</p></div><p class="colorTittleP">Color error:</p><div id="errorColor" class="cellColor" style="background-color:'+errorColor+'"><p id="colorId">'+errorColor+'</p></div></div>';
    }

    return html;
}

window.getStyleColorPicker = function getStyleColorPicker(aceptColor,containerAceptColor,backgroundPickerColor) {
    var html = '<div class="colorZone withOutStyle"><p>Sin estilo de color del picker</p><div id="cellColor"></div></div>';
    if (aceptColor != "" ||containerAceptColor != "" || backgroundPickerColor != "") {
        html = '<div class="colorZone"><p class="nextColor">Estilos picker selector</p><p class="colorOKPicker">Color texto OK:</p><div id="aceptColor"class="cellColor" style="background-color:'+aceptColor+'"><p id="colorId">'+aceptColor+'</p></div><p class="colorTittleP">Color contenedor OK:</p><div id="containerAceptColor"class="cellColor"  style="background-color:'+containerAceptColor+'"><p id="colorId">'+containerAceptColor+'</p></div><p class="colorTittleP">Color fondo:</p><div id="backgroundPickerColor" class="cellColor"  style="background-color:'+backgroundPickerColor+'"><p id="colorId">'+backgroundPickerColor+'</p></div></div>';
    }

    return html;
}

window.getStyleSize = function getStyleSize (sizeTitle, sizeError) {
    var htmlFontSize =  '<div class="colorZone withOutStyle"><p>Sin estilo de fuente de tamaño</p></div>';
    if (sizeTitle != "" || sizeError != "") {
        htmlFontSize = '<div class="sizeZone"><p>Tamaño titulo:</p><input id="sizeTitle"type="text"name="element" disabled readonly value="'+sizeTitle+'"><p>Tamaño texto error:</p><input id="sizeError"type="text"name="element" disabled readonly value="'+sizeError+'"></div>';
    }

    return htmlFontSize;
}

window.getAlignFont = function getAlignFont(align,font) {
    var htmlAlignFont =  '<div class="colorZone withOutStyle"><p>Sin estilo de alineación o tipo de fuente</p></div>';
    if (align != "" || font != "") {
        htmlAlignFont = '<div class="sizeZone alignZone"><p>Alineación:</p><input id="alignTitle" type="text"name="element" disabled readonly value="'+align+'"><p>Fuente:</p><input id="fontField"type="text"name="element" disabled readonly value="'+font+'"></div>';
    }

    return htmlAlignFont;
}

window.getStylesJson = function getStylesJson(cellColor,titleColor,errorColor,sizeTitle, sizeError,aceptColor,containerAceptColor,backgroundPickerColor,align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff) {
    var style = {}
    var haveStyle = false;
    
    //-- STYLES --
    if (cellColor.length > 0) {
        style["backgroundColorField"] = cellColor
        haveStyle = true;
    }
    if (titleColor.length > 0) {
        style["titleColor"] = titleColor
        haveStyle = true;
    }
    if (errorColor.length > 0) {
        style["errorColor"] = errorColor
        haveStyle = true;
    }
    if (sizeTitle.length > 0) {
        style["sizeTitle"] = parseInt(sizeTitle)
        haveStyle = true;
    }
    if (sizeError.length > 0) {
        style["sizeError"] = parseInt(sizeError)
        haveStyle = true;
    }
    if (aceptColor.length > 0) {
        style["acceptColorPicker"] = aceptColor
        haveStyle = true;
    }
    if (containerAceptColor.length > 0) {
        style["containerAcceptColorPicker"] = containerAceptColor
        haveStyle = true;
    }
    if (backgroundPickerColor.length > 0) {
        style["backgroundPickerColorPicker"] = backgroundPickerColor
        haveStyle = true;
    }
    if (align.length > 0) {
        style["align"] = align
        haveStyle = true;
    }
    if (font.length > 0) {
        style["font"] = font
        haveStyle = true;
    }
    if (imageMandatory.length > 0) {
        style["mandatoryIcon"] = imageMandatory
        haveStyle = true;
    }
    if (imageCheckBoxOn.length > 0 && imageCheckBoxOff.length > 0) {
        var checkBox = {}
        checkBox["checkBoxOn"] = imageCheckBoxOn
        checkBox["checkBoxOff"] = imageCheckBoxOff
        style["checkBox"] = checkBox
        haveStyle = true;
    }
    if (haveStyle) {
        return style;
    }
    else {
        return null;
    }
}

