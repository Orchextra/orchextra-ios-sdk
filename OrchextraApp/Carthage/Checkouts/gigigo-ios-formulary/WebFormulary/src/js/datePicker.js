
//======================================
//            DATE   PICKER           //
//======================================


//-- DATE PICKER YA CREADO SOLO MOSTRAR --
window.createDatePickerField = function createDatePickerField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,minAgeContainer,align,font,imageMandatory,isEditing, isHidden) {
    var isMandatory = ""
    if (mandatory) {
        isMandatory = "checked"
    }
    var isEditingCheck = ""
    if (isEditing) {
        isEditingCheck = "checked"
    }
    var isHiddenChecked = ""
    if (isHidden) {
        isHiddenChecked = "checked"
    }

    //-- Recover Styles --
    var htmlColorBasic = getStyleColor(cellColor,titleColor,errorColor);
    var htmlFontSize = getStyleSize (sizeTitle, sizeError);
    var htmlColorPicker = getStyleColorPicker (aceptColor,containerAceptColor,backgroundPickerColor);
    var htmlAlingFont = getAlignFont(align,font)
    var htmlImages = recoverHtmlImageMandatory(imageMandatory)

    var styles = htmlFontSize + htmlColorBasic + htmlAlingFont + htmlImages + htmlColorPicker;

    var html = require('html-loader!../aux/auxDatePickerCreated.html')
            .replace('{{styles}}',styles)
            .replace('{{keyTextField}}',keyTextField)
            .replace('{{title}}',title)
            .replace('{{error}}',error)
            .replace('{{isMandatory}}',isMandatory)
            .replace('{{isEditingCheck}}',isEditingCheck)
            .replace('{{isHiddenChecked}}',isHiddenChecked)
            .replace('{{acceptButtonTextField}}',acceptButtonTextField)
            .replace('{{minAgeContainer}}',minAgeContainer)
            .replace(/\{\{indexField\}\}/g,indexField)


    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

window.saveDatePickerField = function saveDatePickerField(keyTextField,type,title,textError,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,minAgeContainer,align,font,imageMandatory,isEditing, isHidden) {
    
    //-- MANDATORY FIELDS --

    var itemSave = {
        "key":keyTextField,
        "tag":indexField,
        "type":type,
        "label":title
    }
    
    //-- OPTIONAL FIELDS --

    if (mandatory) {
        itemSave["mandatory"] = mandatory
    }
    if (isEditing) {
        itemSave["isEditing"] = isEditing
    }
    if (isHidden) {
        itemSave["isHidden"] = isHidden
    }
    if (textError.length > 0) {
        itemSave["textError"] = textError
    }               
    if (acceptButtonTextField.length > 0) {
        itemSave["textAcceptButton"] = acceptButtonTextField
    }                
    if (minAgeContainer.length > 0) {
        itemSave["minAge"] = parseInt(minAgeContainer) 
        itemSave["validator"] = "age"
    }  

    var styles = getStylesJson(cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,align,font,imageMandatory,"","");
    if (styles != null) {
        itemSave["style"] = styles
    }    

    //-- SAVE ITEMS --
    listFieldsResult.push(itemSave)
        
    indexField++;
}
