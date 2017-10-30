
//======================================
//               TEXT (YA CREADO)     //  
//======================================
            
window.createField = function createField(keyTextField,title,placeHolder,error,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,customValidator, isPassword, isCompare, compareKeysField, textErrorCompare,isEditing, isHidden, errorValidator) {
    var isMandatory = ""
    if (mandatory) {
        isMandatory = "checked"
    }
    var isPasswordChecked = ""
    if (isPassword) {
        isPasswordChecked = "checked"
    }
    var isCompareChecked = ""
    if (isCompare) {
        isCompareChecked = "checked"
    }
    var isEditingChecked = ""
    if (isEditing) {
        isEditingChecked = "checked"
    } 
    var isHiddenChecked = ""
    if (isHidden) {
        isHiddenChecked = "checked"
    }

    //-- Recover Styles --
    var htmlBackgroundColor = getStyleColor(cellColor,titleColor,errorColor);
    var htmlFontSize = getStyleSize (sizeTitle, sizeError);
    var htmlAlingFont = getAlignFont(align,font)
    var htmlImages = recoverHtmlImageMandatory(imageMandatory)
    
    var styles =  htmlFontSize + htmlBackgroundColor + htmlAlingFont + htmlImages;

    var htmlCustomValidator = ""    
    if (validator == "customValidator") {
        htmlCustomValidator = '<input type="text" class="customValidatorCreated" name="customValidatorTextField" id="customValidatorTextField" disabled value="'+customValidator+'">'
    }

    var htmlTextErrorValidator = ""
    if (validator != "None") {
        htmlTextErrorValidator = '<div class="errorTextField"><p class="textErrorP">Texto error:</p><input class="textErrorCreated" type="text" name="errorTextField" id="errorTextField" disabled value="{{errorValidator}}">';

        if (validator == "lengthText") {
            htmlTextErrorValidator += '<p>minLength:</p><input class="inputWidth" type="text" name="minLength"id="minLength" disabled readonly value="{{minLength}}"><p>maxLength:</p><input class="inputWidth" type="text" name="maxLength"id="maxLength" disabled readonly value="{{maxLength}}">';              
        }

        htmlTextErrorValidator += '</div>';
    }

    var htmlTextErrorCompare = ""
    if (isCompare) {
        htmlTextErrorCompare = '<p>Keys Compare:</p> <input type="text" name="compareKeysField" id="compareKeysField" disabled value="{{compareKeysField}}"><p>Text Error</p><input type="text" name="textErrorCompareFix" id="textErrorCompareFix" class="customValidatorCreated" disabled value="'+textErrorCompare+'">'
    }

    var html = require('html-loader!../aux/auxTextCreated.html')
            .replace('{{htmlTextErrorCompare}}',htmlTextErrorCompare)
            .replace('{{htmlTextErrorValidator}}',htmlTextErrorValidator)
            .replace('{{styles}}',styles)
            .replace('{{keyTextField}}',keyTextField)
            .replace('{{title}}',title)
            .replace('{{placeHolder}}',placeHolder)
            .replace('{{error}}',error)
            .replace('{{isMandatory}}',isMandatory)
            .replace('{{keyboard}}',keyboard)
            .replace('{{htmlCustomValidator}}',htmlCustomValidator)
            .replace('{{minLength}}',minLength)
            .replace('{{maxLength}}',maxLength)
            .replace('{{isPasswordChecked}}',isPasswordChecked)
            .replace('{{isCompareChecked}}',isCompareChecked)
            .replace('{{compareKeysField}}',compareKeysField)
            .replace('{{isEditingChecked}}',isEditingChecked)
            .replace('{{isHiddenChecked}}',isHiddenChecked)
            .replace('{{validator}}',validator)
            .replace('{{errorValidator}}',errorValidator)
            .replace(/\{\{indexField\}\}/g,indexField)

    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

window.saveField = function saveField(keyTextField,type,title,placeHolder,textError,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,customValidator, isPassword, isCompare, compareKeysField, textErrorCompare,isEditing, isHidden, errorValidator) {
    //-- Mandatory Fiedls --
    var itemSave = {
        "tag":indexField,
        "key":keyTextField,
        "type":type,
        "label":title
    }

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
    if (placeHolder.length > 0) {
        itemSave["placeHolder"] = placeHolder
    }                
    if (minLength.length > 0) {
        itemSave["minLength"] = parseInt(minLength)
    }                
    if (maxLength.length > 0) {
        itemSave["maxLength"] = parseInt(maxLength)
    }                
    if (keyboard != "None") {
        itemSave["keyboard"] = keyboard
    }
    if (isPassword) {
        itemSave["isPassword"] = isPassword
    }
    if (validator != "None") {
        itemSave["validator"] = validator
        if (validator == "customValidator") {
            itemSave["customValidator"] = customValidator
        }
        itemSave["textErrorValidate"] = errorValidator        
    }
    if (isCompare) {
        itemSave["compare"] = isCompare
        itemSave["itemsCompare"] = compareKeysField.split(","); 
        console.log(textErrorCompare);
        itemSave["textErrorCompare"] = textErrorCompare;
    }
    
    
    //-- OPTIONAL FIELDS --
    var styles = getStylesJson(cellColor,titleColor,errorColor,sizeTitle,sizeError,"","","",align,font,imageMandatory,"","");

    if (styles != null) {
        itemSave["style"] = styles
    } 
    
    listFieldsResult.push(itemSave)
    
    /*
    for (var i=0; i<listFieldsResult.length; i++) {
        $.each(listFieldsResult[i], function(index, val) {
            console.log("key:"+index+" - value:"+val);
        });
    }*/
    
    indexField++;
}
