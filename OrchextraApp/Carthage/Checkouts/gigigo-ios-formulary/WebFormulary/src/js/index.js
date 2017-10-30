
//======================================
//               TEXT (YA CREADO)     //
//======================================

window.createIndexField = function createIndexField(keyTextField,title,cellColor,titleColor,sizeTitle,align,font) {
    
    //-- Recover Styles --
    var htmlBackgroundColor = getStyleColor(cellColor,titleColor,"");
    var htmlFontSize = getStyleSize (sizeTitle, "");
    var htmlAlingFont = getAlignFont(align,font)
    
    var styles =  htmlFontSize + htmlBackgroundColor + htmlAlingFont;
        
    var html = require('html-loader!../aux/auxIndexCreated.html')
            .replace('{{styles}}',styles)
            .replace('{{keyTextField}}',keyTextField)
            .replace('{{title}}',title)
            .replace(/\{\{indexField\}\}/g,indexField)


    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

window.saveIndexField = function saveIndexField(keyTextField,type,title,cellColor,titleColor,sizeTitle,align,font) {
    //-- Mandatory Fiedls --
    var itemSave = {
        "tag":indexField,
        "key":keyTextField,
        "type":type,
        "label":title
    }
    
    
    //-- OPTIONAL FIELDS --
    var styles = getStylesJson(cellColor,titleColor,"",sizeTitle,"","","","",align,font,"","","");
    
    if (styles != null) {
        itemSave["style"] = styles
    }
    
    listFieldsResult.push(itemSave)
 
    indexField++;
}
