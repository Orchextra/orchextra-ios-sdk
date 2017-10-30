/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 20);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

var require;var require;/*!
 * clipboard.js v1.5.12
 * https://zenorocha.github.io/clipboard.js
 *
 * Licensed MIT © Zeno Rocha
 */
!function(t){if(true)module.exports=t();else if("function"==typeof define&&define.amd)define([],t);else{var e;e="undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self?self:this,e.Clipboard=t()}}(function(){var t,e,n;return function t(e,n,o){function i(a,c){if(!n[a]){if(!e[a]){var s="function"==typeof require&&require;if(!c&&s)return require(a,!0);if(r)return require(a,!0);var l=new Error("Cannot find module '"+a+"'");throw l.code="MODULE_NOT_FOUND",l}var u=n[a]={exports:{}};e[a][0].call(u.exports,function(t){var n=e[a][1][t];return i(n?n:t)},u,u.exports,t,e,n,o)}return n[a].exports}for(var r="function"==typeof require&&require,a=0;a<o.length;a++)i(o[a]);return i}({1:[function(t,e,n){var o=t("matches-selector");e.exports=function(t,e,n){for(var i=n?t:t.parentNode;i&&i!==document;){if(o(i,e))return i;i=i.parentNode}}},{"matches-selector":5}],2:[function(t,e,n){function o(t,e,n,o,r){var a=i.apply(this,arguments);return t.addEventListener(n,a,r),{destroy:function(){t.removeEventListener(n,a,r)}}}function i(t,e,n,o){return function(n){n.delegateTarget=r(n.target,e,!0),n.delegateTarget&&o.call(t,n)}}var r=t("closest");e.exports=o},{closest:1}],3:[function(t,e,n){n.node=function(t){return void 0!==t&&t instanceof HTMLElement&&1===t.nodeType},n.nodeList=function(t){var e=Object.prototype.toString.call(t);return void 0!==t&&("[object NodeList]"===e||"[object HTMLCollection]"===e)&&"length"in t&&(0===t.length||n.node(t[0]))},n.string=function(t){return"string"==typeof t||t instanceof String},n.fn=function(t){var e=Object.prototype.toString.call(t);return"[object Function]"===e}},{}],4:[function(t,e,n){function o(t,e,n){if(!t&&!e&&!n)throw new Error("Missing required arguments");if(!c.string(e))throw new TypeError("Second argument must be a String");if(!c.fn(n))throw new TypeError("Third argument must be a Function");if(c.node(t))return i(t,e,n);if(c.nodeList(t))return r(t,e,n);if(c.string(t))return a(t,e,n);throw new TypeError("First argument must be a String, HTMLElement, HTMLCollection, or NodeList")}function i(t,e,n){return t.addEventListener(e,n),{destroy:function(){t.removeEventListener(e,n)}}}function r(t,e,n){return Array.prototype.forEach.call(t,function(t){t.addEventListener(e,n)}),{destroy:function(){Array.prototype.forEach.call(t,function(t){t.removeEventListener(e,n)})}}}function a(t,e,n){return s(document.body,t,e,n)}var c=t("./is"),s=t("delegate");e.exports=o},{"./is":3,delegate:2}],5:[function(t,e,n){function o(t,e){if(r)return r.call(t,e);for(var n=t.parentNode.querySelectorAll(e),o=0;o<n.length;++o)if(n[o]==t)return!0;return!1}var i=Element.prototype,r=i.matchesSelector||i.webkitMatchesSelector||i.mozMatchesSelector||i.msMatchesSelector||i.oMatchesSelector;e.exports=o},{}],6:[function(t,e,n){function o(t){var e;if("INPUT"===t.nodeName||"TEXTAREA"===t.nodeName)t.focus(),t.setSelectionRange(0,t.value.length),e=t.value;else{t.hasAttribute("contenteditable")&&t.focus();var n=window.getSelection(),o=document.createRange();o.selectNodeContents(t),n.removeAllRanges(),n.addRange(o),e=n.toString()}return e}e.exports=o},{}],7:[function(t,e,n){function o(){}o.prototype={on:function(t,e,n){var o=this.e||(this.e={});return(o[t]||(o[t]=[])).push({fn:e,ctx:n}),this},once:function(t,e,n){function o(){i.off(t,o),e.apply(n,arguments)}var i=this;return o._=e,this.on(t,o,n)},emit:function(t){var e=[].slice.call(arguments,1),n=((this.e||(this.e={}))[t]||[]).slice(),o=0,i=n.length;for(o;i>o;o++)n[o].fn.apply(n[o].ctx,e);return this},off:function(t,e){var n=this.e||(this.e={}),o=n[t],i=[];if(o&&e)for(var r=0,a=o.length;a>r;r++)o[r].fn!==e&&o[r].fn._!==e&&i.push(o[r]);return i.length?n[t]=i:delete n[t],this}},e.exports=o},{}],8:[function(e,n,o){!function(i,r){if("function"==typeof t&&t.amd)t(["module","select"],r);else if("undefined"!=typeof o)r(n,e("select"));else{var a={exports:{}};r(a,i.select),i.clipboardAction=a.exports}}(this,function(t,e){"use strict";function n(t){return t&&t.__esModule?t:{"default":t}}function o(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}var i=n(e),r="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol?"symbol":typeof t},a=function(){function t(t,e){for(var n=0;n<e.length;n++){var o=e[n];o.enumerable=o.enumerable||!1,o.configurable=!0,"value"in o&&(o.writable=!0),Object.defineProperty(t,o.key,o)}}return function(e,n,o){return n&&t(e.prototype,n),o&&t(e,o),e}}(),c=function(){function t(e){o(this,t),this.resolveOptions(e),this.initSelection()}return t.prototype.resolveOptions=function t(){var e=arguments.length<=0||void 0===arguments[0]?{}:arguments[0];this.action=e.action,this.emitter=e.emitter,this.target=e.target,this.text=e.text,this.trigger=e.trigger,this.selectedText=""},t.prototype.initSelection=function t(){this.text?this.selectFake():this.target&&this.selectTarget()},t.prototype.selectFake=function t(){var e=this,n="rtl"==document.documentElement.getAttribute("dir");this.removeFake(),this.fakeHandlerCallback=function(){return e.removeFake()},this.fakeHandler=document.body.addEventListener("click",this.fakeHandlerCallback)||!0,this.fakeElem=document.createElement("textarea"),this.fakeElem.style.fontSize="12pt",this.fakeElem.style.border="0",this.fakeElem.style.padding="0",this.fakeElem.style.margin="0",this.fakeElem.style.position="absolute",this.fakeElem.style[n?"right":"left"]="-9999px",this.fakeElem.style.top=(window.pageYOffset||document.documentElement.scrollTop)+"px",this.fakeElem.setAttribute("readonly",""),this.fakeElem.value=this.text,document.body.appendChild(this.fakeElem),this.selectedText=(0,i.default)(this.fakeElem),this.copyText()},t.prototype.removeFake=function t(){this.fakeHandler&&(document.body.removeEventListener("click",this.fakeHandlerCallback),this.fakeHandler=null,this.fakeHandlerCallback=null),this.fakeElem&&(document.body.removeChild(this.fakeElem),this.fakeElem=null)},t.prototype.selectTarget=function t(){this.selectedText=(0,i.default)(this.target),this.copyText()},t.prototype.copyText=function t(){var e=void 0;try{e=document.execCommand(this.action)}catch(n){e=!1}this.handleResult(e)},t.prototype.handleResult=function t(e){e?this.emitter.emit("success",{action:this.action,text:this.selectedText,trigger:this.trigger,clearSelection:this.clearSelection.bind(this)}):this.emitter.emit("error",{action:this.action,trigger:this.trigger,clearSelection:this.clearSelection.bind(this)})},t.prototype.clearSelection=function t(){this.target&&this.target.blur(),window.getSelection().removeAllRanges()},t.prototype.destroy=function t(){this.removeFake()},a(t,[{key:"action",set:function t(){var e=arguments.length<=0||void 0===arguments[0]?"copy":arguments[0];if(this._action=e,"copy"!==this._action&&"cut"!==this._action)throw new Error('Invalid "action" value, use either "copy" or "cut"')},get:function t(){return this._action}},{key:"target",set:function t(e){if(void 0!==e){if(!e||"object"!==("undefined"==typeof e?"undefined":r(e))||1!==e.nodeType)throw new Error('Invalid "target" value, use a valid Element');if("copy"===this.action&&e.hasAttribute("disabled"))throw new Error('Invalid "target" attribute. Please use "readonly" instead of "disabled" attribute');if("cut"===this.action&&(e.hasAttribute("readonly")||e.hasAttribute("disabled")))throw new Error('Invalid "target" attribute. You can\'t cut text from elements with "readonly" or "disabled" attributes');this._target=e}},get:function t(){return this._target}}]),t}();t.exports=c})},{select:6}],9:[function(e,n,o){!function(i,r){if("function"==typeof t&&t.amd)t(["module","./clipboard-action","tiny-emitter","good-listener"],r);else if("undefined"!=typeof o)r(n,e("./clipboard-action"),e("tiny-emitter"),e("good-listener"));else{var a={exports:{}};r(a,i.clipboardAction,i.tinyEmitter,i.goodListener),i.clipboard=a.exports}}(this,function(t,e,n,o){"use strict";function i(t){return t&&t.__esModule?t:{"default":t}}function r(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}function a(t,e){if(!t)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!e||"object"!=typeof e&&"function"!=typeof e?t:e}function c(t,e){if("function"!=typeof e&&null!==e)throw new TypeError("Super expression must either be null or a function, not "+typeof e);t.prototype=Object.create(e&&e.prototype,{constructor:{value:t,enumerable:!1,writable:!0,configurable:!0}}),e&&(Object.setPrototypeOf?Object.setPrototypeOf(t,e):t.__proto__=e)}function s(t,e){var n="data-clipboard-"+t;if(e.hasAttribute(n))return e.getAttribute(n)}var l=i(e),u=i(n),f=i(o),d=function(t){function e(n,o){r(this,e);var i=a(this,t.call(this));return i.resolveOptions(o),i.listenClick(n),i}return c(e,t),e.prototype.resolveOptions=function t(){var e=arguments.length<=0||void 0===arguments[0]?{}:arguments[0];this.action="function"==typeof e.action?e.action:this.defaultAction,this.target="function"==typeof e.target?e.target:this.defaultTarget,this.text="function"==typeof e.text?e.text:this.defaultText},e.prototype.listenClick=function t(e){var n=this;this.listener=(0,f.default)(e,"click",function(t){return n.onClick(t)})},e.prototype.onClick=function t(e){var n=e.delegateTarget||e.currentTarget;this.clipboardAction&&(this.clipboardAction=null),this.clipboardAction=new l.default({action:this.action(n),target:this.target(n),text:this.text(n),trigger:n,emitter:this})},e.prototype.defaultAction=function t(e){return s("action",e)},e.prototype.defaultTarget=function t(e){var n=s("target",e);return n?document.querySelector(n):void 0},e.prototype.defaultText=function t(e){return s("text",e)},e.prototype.destroy=function t(){this.listener.destroy(),this.clipboardAction&&(this.clipboardAction.destroy(),this.clipboardAction=null)},e}(u.default);t.exports=d})},{"./clipboard-action":8,"good-listener":4,"tiny-emitter":7}]},{},[9])(9)});

/***/ }),
/* 1 */
/***/ (function(module, exports) {

window.listFonts = 'AcademyEngravedLetPlain,AlNile-Bold,AlNile,AmericanTypewriter,AmericanTypewriter-Bold,AmericanTypewriter-Condensed,AmericanTypewriter-CondensedBold,AmericanTypewriter-CondensedLight,AmericanTypewriter-Light,AppleColorEmoji,AppleSDGothicNeo-Thin,AppleSDGothicNeo-UltraLight,AppleSDGothicNeo-Light,AppleSDGothicNeo-Regular,AppleSDGothicNeo-Medium,AppleSDGothicNeo-SemiBold,AppleSDGothicNeo-Bold,AppleSDGothicNeo-Medium,ArialMT,Arial-BoldItalicMT,Arial-BoldMT,Arial-ItalicMT,ArialHebrew,ArialHebrew-Bold,ArialHebrew-Light,ArialRoundedMTBold,Avenir-Black,Avenir-BlackOblique,Avenir-Book,Avenir-BookOblique,Avenir-Heavy,Avenir-HeavyOblique,Avenir-Light,Avenir-LightOblique,Avenir-Medium,Avenir-MediumOblique,Avenir-Oblique,Avenir-Roman,AvenirNext-Bold,AvenirNext-BoldItalic,AvenirNext-DemiBold,AvenirNext-DemiBoldItalic,AvenirNext-Heavy,AvenirNext-HeavyItalic,AvenirNext-Italic,AvenirNext-Medium,AvenirNext-MediumItalic,AvenirNext-Regular,AvenirNext-UltraLight,AvenirNext-UltraLightItalic,AvenirNextCondensed-Bold,AvenirNextCondensed-BoldItalic,AvenirNextCondensed-DemiBold,AvenirNextCondensed-DemiBoldItalic,AvenirNextCondensed-Heavy,AvenirNextCondensed-HeavyItalic,AvenirNextCondensed-Italic,AvenirNextCondensed-Medium,AvenirNextCondensed-MediumItalic,AvenirNextCondensed-Regular,AvenirNextCondensed-UltraLight,AvenirNextCondensed-UltraLightItalic,BanglaSangamMN,BanglaSangamMN-Bold,Baskerville,Baskerville-Bold,Baskerville-BoldItalic,Baskerville-Italic,Baskerville-SemiBold,Baskerville-SemiBoldItalic,BodoniOrnamentsITCTT,BodoniSvtyTwoITCTT-Bold,BodoniSvtyTwoITCTT-Book,BodoniSvtyTwoITCTT-BookIta,BodoniSvtyTwoOSITCTT-Bold,BodoniSvtyTwoOSITCTT-Book,BodoniSvtyTwoOSITCTT-BookIt,BodoniSvtyTwoSCITCTT-Book,BradleyHandITCTT-Bold,ChalkboardSE-Bold,ChalkboardSE-Light,ChalkboardSE-Regular,Chalkduster,Cochin,Cochin-Bold,Cochin-BoldItalic,Cochin-Italic,Copperplate,Copperplate-Bold,Copperplate-Light,Courier,Courier-Bold,Courier-BoldOblique,Courier-Oblique,CourierNewPS-BoldItalicMT,CourierNewPS-BoldMT,CourierNewPS-ItalicMT,CourierNewPSMT,DINAlternate-Bold,DINCondensed-Bold,DamascusBold,Damascus,DamascusLight,DamascusMedium,DamascusSemiBold,DevanagariSangamMN,DevanagariSangamMN-Bold,Didot,Didot-Bold,Didot-Italic,DiwanMishafi,EuphemiaUCAS,EuphemiaUCAS-Bold,EuphemiaUCAS-Italic,Farah,Futura-CondensedExtraBold,Futura-CondensedMedium,Futura-Medium,Futura-MediumItalic,GeezaPro,GeezaPro-Bold,Georgia,Georgia-Bold,Georgia-BoldItalic,Georgia-Italic,GillSans,GillSans-SemiBold,GillSans-SemiBoldItalic,GillSans-Bold,GillSans-BoldItalic,GillSans-UltraBold,GillSans-Italic,GillSans-Light,GillSans-LightItalic,GujaratiSangamMN,GujaratiSangamMN-Bold,GurmukhiMN,GurmukhiMN-Bold,STHeitiSC-Light,STHeitiSC-Medium,STHeitiTC-Light,STHeitiTC-Medium,Helvetica,Helvetica-Bold,Helvetica-BoldOblique,Helvetica-Light,Helvetica-LightOblique,Helvetica-Oblique,HelveticaNeue,HelveticaNeue-Bold,HelveticaNeue-BoldItalic,HelveticaNeue-CondensedBlack,HelveticaNeue-CondensedBold,HelveticaNeue-Italic,HelveticaNeue-Light,HelveticaNeue-LightItalic,HelveticaNeue-Medium,HelveticaNeue-MediumItalic,HelveticaNeue-UltraLight,HelveticaNeue-UltraLightItalic,HelveticaNeue-Thin,HelveticaNeue-ThinItalic,HiraMinProN-W,HiraMinProN-W,HiraginoSans-W,HiraginoSans-W,HoeflerText-Black,HoeflerText-BlackItalic,HoeflerText-Italic,HoeflerText-Regular,IowanOldStyle-Bold,IowanOldStyle-BoldItalic,IowanOldStyle-Italic,IowanOldStyle-Roman,Kailasa,Kailasa-Bold,KannadaSangamMN,KannadaSangamMN-Bold,KhmerSangamMN,KohinoorBangla-Light,KohinoorBangla-Regular,KohinoorBangla-Semibold,KohinoorDevanagari-Book,KohinoorDevanagari-Light,KohinoorDevanagari-Medium,KohinoorTelugu-Light,KohinoorTelugu-Regular,KohinoorTelugu-Medium,LaoSangamMN,MalayalamSangamMN,MalayalamSangamMN-Bold,Menlo-BoldItalic,Menlo-Regular,Menlo-Bold,Menlo-Italic,MarkerFelt-Thin,MarkerFelt-Wide,Noteworthy-Bold,Noteworthy-Light,Optima-Bold,Optima-BoldItalic,Optima-ExtraBlack,Optima-Italic,Optima-Regular,OriyaSangamMN,OriyaSangamMN-Bold,Palatino-Bold,Palatino-BoldItalic,Palatino-Italic,Palatino-Roman,Papyrus,Papyrus-Condensed,PartyLetPlain,PingFangHK-Ultralight,PingFangHK-Light,PingFangHK-Thin,PingFangHK-Regular,PingFangHK-Medium,PingFangHK-Semibold,PingFangSC-Ultralight,PingFangSC-Light,PingFangSC-Thin,PingFangSC-Regular,PingFangSC-Medium,PingFangSC-Semibold,PingFangTC-Ultralight,PingFangTC-Light,PingFangTC-Thin,PingFangTC-Regular,PingFangTC-Medium,PingFangTC-Semibold,SavoyeLetPlain,SinhalaSangamMN,SinhalaSangamMN-Bold,SnellRoundhand,SnellRoundhand-Black,SnellRoundhand-Bold,Symbol,TamilSangamMN,TamilSangamMN-Bold,TeluguSangamMN,TeluguSangamMN-Bold,Thonburi,Thonburi-Bold,Thonburi-Light,TimesNewRomanPS-BoldItalicMT,TimesNewRomanPS-BoldMT,TimesNewRomanPS-ItalicMT,TimesNewRomanPSMT,Trebuchet-BoldItalic,TrebuchetMS,TrebuchetMS-Bold,TrebuchetMS-Italic,Verdana,Verdana-Bold,Verdana-BoldItalic,Verdana-Italic,ZapfDingbatsITC,Zapfino';

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

//======================================
//        BOOLEAN   (YA CREADO)       //
//======================================
            
window.createBooleanField = function createBooleanField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff, isEditing, isHidden) {
    var isMandatory = ""
    if (mandatory) {
        isMandatory = "checked"
    }
    var isEditingValueCheck = ""
    if (isEditing) {
        isEditingValueCheck = "checked"
    }
    var isHiddenChecked = ""
    if (isHidden) {
        isHiddenChecked = "checked"
    }

    //-- Recover Styles --
    var htmlBackgroundColor = getStyleColor(cellColor,titleColor,errorColor);
    var htmlFontSize = getStyleSize (sizeTitle, sizeError);
    var htmlAlingFont = getAlignFont(align,font)
    var htmlImages = recoverHtmlAllImage(imageMandatory,imageCheckBoxOn,imageCheckBoxOff)

    var styles =  htmlFontSize + htmlBackgroundColor + htmlAlingFont + htmlImages;

    var html = __webpack_require__(22)
            .replace('{{styles}}',styles)
            .replace('{{keyTextField}}',keyTextField)
            .replace('{{title}}',title)
            .replace('{{error}}',error)
            .replace('{{isMandatory}}',isMandatory)
            .replace('{{isEditingValueCheck}}',isEditingValueCheck)
            .replace('{{isHiddenChecked}}',isHiddenChecked)
            .replace(/\{\{indexField\}\}/g,indexField)


    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

window.saveBooleanField = function saveBooleanField(keyTextField,type,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff, isEditing, isHidden) {
    //-- Mandatory Fiedls --
    var itemSave = {
        "key":keyTextField,
        "tag":indexField,
        "type":type,
        "label":title
    }

    if (mandatory) {
        itemSave["mandatory"] = mandatory
    }   
    if (error.length > 0) {
        itemSave["textError"] = error
    }               
    if (mandatory) {
        itemSave["validator"] = "bool"
    }
    if (isEditing) {
        itemSave["isEditing"] = isEditing
    }
    if (isHidden) {
        itemSave["isHidden"] = isHidden
    }
    
    //-- OPTIONAL FIELDS --
    var styles = getStylesJson(cellColor,titleColor,errorColor,sizeTitle,sizeError,"","","",align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff);

    if (styles != null) {
        itemSave["style"] = styles
    } 
    
    listFieldsResult.push(itemSave)

    indexField++;
}



/***/ }),
/* 3 */
/***/ (function(module, exports) {

window.colorBasicZone = ' <p>Color de la celda:</p><input type="color" value="#ffffff" id="cellColor" class="cellColorCreate"><input id="cellColorHex" class="inputColorHex" placeholder="#ffffff"> <p class="colorTittleP">Color titulo:</p><input type="color" value="#ffffff" id="titleColor" class="cellColorCreate"><input id="titleColorHex" class="inputColorHex" placeholder="#ffffff"> <p class="colorTittleP">Color Error:</p><input type="color" value="#ffffff" id="errorColor" class="cellColorCreate"><input id="errorColorHex" class="inputColorHex" placeholder="#ffffff">';

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {


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

    var html = __webpack_require__(21)
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


/***/ }),
/* 5 */
/***/ (function(module, exports) {



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

/***/ }),
/* 6 */
/***/ (function(module, exports) {


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


/***/ }),
/* 7 */
/***/ (function(module, exports) {

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





/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {


//======================================
//               TEXT (YA CREADO)     //
//======================================

window.createIndexField = function createIndexField(keyTextField,title,cellColor,titleColor,sizeTitle,align,font) {
    
    //-- Recover Styles --
    var htmlBackgroundColor = getStyleColor(cellColor,titleColor,"");
    var htmlFontSize = getStyleSize (sizeTitle, "");
    var htmlAlingFont = getAlignFont(align,font)
    
    var styles =  htmlFontSize + htmlBackgroundColor + htmlAlingFont;
        
    var html = __webpack_require__(23)
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


/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {



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
        html = __webpack_require__(18)
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Picker") {
        idPickerField = 1; // Reset Picker
        html = __webpack_require__(16)
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "DatePicker") {
        html = __webpack_require__(14)
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Boolean") {
        htmlImage = getHtmlAllImage();
        html = __webpack_require__(13)
            .replace('{{colorBasicZone}}',colorBasicZone)
            .replace('{{htmlFont}}',htmlFont)
            .replace('{{htmlImage}}',htmlImage)
    }
    else if (typeField == "Index") {
        html = __webpack_require__(15)
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



/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {


//======================================
//               PICKER               //
//======================================
window.idPickerField = 1
window.addContainerPicker = function addContainerPicker() {
    $("#pickerFieldsInsert").append('<div class="containerPickerField" id="containerPickerField'+idPickerField+'"><input id="inputKeyPickerField'+idPickerField+'" type="text" name="element" placeholder="Clave Picker"><input id="inputValuePickerField'+idPickerField+'" type="text" name="element" placeholder="Valor picker"><p onclick="removeContainerPicker('+idPickerField+')">-</p></div>');
    idPickerField++;
}

window.removeContainerPicker = function removeContainerPicker(idContainerPicker) {
    $("#containerPickerField"+idContainerPicker).slideUp(function(){
           $("#containerPickerField"+idContainerPicker).remove()
    });
}

//-- PICKER YA CREADO SOLO MOSTRAR --
window.createPickerField = function createPickerField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,align,font,imageMandatory,isEditing, isHidden) {
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

    //-- Create options fields --
    var htmlPickerItems = '';
    for (var i = 0; i < idPickerField; i++) {
        var idKey = $("#inputKeyPickerField"+i).val()
        var idValue = $("#inputValuePickerField"+i).val()

        if (idKey != undefined && idValue != undefined) {
                htmlPickerItems = htmlPickerItems + '<div class="containerPickerField"><input type="text" name="element" value="'+idKey+'" disabled readonly><input type="text" name="element" value="'+idValue+'" disabled readonly></div>';
        }
    }

    var html = __webpack_require__(17)
            .replace('{{styles}}',styles)
            .replace('{{keyTextField}}',keyTextField)
            .replace('{{title}}',title)
            .replace('{{error}}',error)
            .replace('{{isMandatory}}',isMandatory)
            .replace('{{isHiddenChecked}}',isHiddenChecked)
            .replace('{{htmlPickerItems}}',htmlPickerItems) 
            .replace('{{isEditingChecked}}',isEditingCheck)
            .replace('{{acceptButtonTextField}}',acceptButtonTextField)
            .replace(/\{\{indexField\}\}/g,indexField)

    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

window.savePickerField = function savePickerField(keyTextField,type,title,textError,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,align,font,imageMandatory,isEditing, isHidden) {
    
    //-- MANDATORY FIELDS --
    var listOptions = [];
    for (var i = 0; i < idPickerField; i++) {
        var idKey = $("#inputKeyPickerField"+i).val()
        var idValue = $("#inputValuePickerField"+i).val()
        var options = {
            "key": idKey,
            "value":idValue
        }
        if (idKey != undefined && idValue != undefined) {
            listOptions.push(options)
        }        
    }

    var itemSave = {
        "key":keyTextField,
        "tag":indexField,
        "type":type,
        "label":title,
        "listOptions":listOptions
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

    var styles = getStylesJson(cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,align,font,imageMandatory,"","");
    if (styles != null) {
        itemSave["style"] = styles
    }    

    //-- SAVE ITEMS --
    listFieldsResult.push(itemSave)
    
    indexField++;
}


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {


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

    var html = __webpack_require__(19)
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


/***/ }),
/* 12 */
/***/ (function(module, exports) {

// http://www.danstools.com/javascript-minify/ 
//======================================
//            VALIDATION              //
//======================================

window.controlError = function controlError(title,keyTextField,font,sizeTitle,sizeError) {
    if (title.length > 0 &&  keyTextField.length > 0) {
        if (font.length > 0) {
            if (sizeTitle.length > 0 && sizeError.length > 0) {
                return true;
            }
            else {
                alert("Si define un tipo de fuente debe elegir el tamaño de fuente para el titulo y el error");
                return false;
            }
        } 
        else {
            return true;
        }
    }
    else {
        alert("Los campos con asterisco son obligatorios");
        return false;
    }
}


//=== TEXTFIELD ===
window.validateTextField = function validateTextField() {
    var keyTextField = $("#keyTextField").val()
    var title = $("#titleTextField").val()
    var placeHolder = $("#palceHolderTextField").val()
    var error = $("#errorTextField").val()
    var custonValidator = $("#custonValidator").val()
    var mandatory = $('#mandatory').is(':checked');
    var keyboard = document.getElementById("selectTypeKeyboard").value;
    var validator = document.getElementById("selectTypeValidator").value;
    var minLength = $("#minLength").val()
    var maxLength = $("#maxLength").val()
    var errorValidator = $("#validatorTextErrorInput").val()

    // Style
    var cellColor = $("#cellColorHex").val()
    var titleColor = $("#titleColorHex").val()
    var errorColor = $("#errorColorHex").val()
    var sizeTitle = $("#sizeTitle").val()
    var sizeError = $("#sizeError").val()
    var align = document.getElementById("selectTypeAlign").value;
    var font = document.getElementById("selectTypeFont").value;
    var imageMandatory = $("#imageMandatory").val()
    var isPassword = $('#passwordTextField').is(':checked');
    var isCompare = $('#compare').is(':checked');
    var compareKeysField = $("#compareKeysField").val()
    var textErrorCompare = $("#compareTextErrorInput").val()
    var isEditing = $('#isEditingTextField').is(':checked');
    var isHidden = $('#isEditingTextField').is(':checked');
    
    
    if (font == "custom") {
        font = $("#custonFont").val()
    }
        
    if (controlError(title,keyTextField,font,sizeTitle,sizeError)) {
        createField(keyTextField,title,placeHolder,error,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,custonValidator, isPassword, isCompare, compareKeysField,textErrorCompare,isEditing, isHidden, errorValidator);
        saveField(keyTextField,"text",title,placeHolder,error,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,custonValidator, isPassword, isCompare, compareKeysField,textErrorCompare,isEditing, isHidden, errorValidator)
    }
}

//=== DATE PICKER ===
window.validateDatePickerField = function validateDatePickerField() {
    var keyTextField = $("#keyTextField").val()
    var title = $("#titleTextField").val()
    var error = $("#errorTextField").val()
    var mandatory = $('#mandatory').is(':checked');

    // Optional
    var acceptButtonTextField = $("#acceptButtonTextField").val()
    var minAgeContainer = $("#minAgeContainer").val()    

    // Style
    var cellColor = $("#cellColorHex").val()
    var titleColor = $("#titleColorHex").val()
    var errorColor = $("#errorColorHex").val()
    var sizeTitle = $("#sizeTitle").val()
    var sizeError = $("#sizeError").val()
    var aceptColor = $("#aceptColorHex").val()
    var containerAceptColor = $("#containerAceptColorHex").val()
    var backgroundPickerColor = $("#backgroundPickerColorHex").val()
    var align = document.getElementById("selectTypeAlign").value;
    var font = document.getElementById("selectTypeFont").value;
    var imageMandatory = $("#imageMandatory").val()
    var isEditing = $('#isEditingTextField').is(':checked');
    var isHidden = $('#isEditingTextField').is(':checked');

    if (font == "custom") {
        font = $("#custonFont").val()
    }
    
    if (error.length == 0) {
        error = "error_generic_field"
    }

    if (controlError(title,keyTextField,font,sizeTitle,sizeError)) {
        createDatePickerField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,minAgeContainer,align,font,imageMandatory,isEditing, isHidden);
        saveDatePickerField(keyTextField,"datePicker",title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,minAgeContainer,align,font,imageMandatory,isEditing, isHidden);
    }
}

//=== PICKER ===
window.validatePickerField = function validatePickerField() {
    var keyTextField = $("#keyTextField").val()
    var title = $("#titleTextField").val()
    var error = $("#errorTextField").val()
    var mandatory = $('#mandatory').is(':checked');

    // Optional
    var acceptButtonTextField = $("#acceptButtonTextField").val()

    // Style
    var cellColor = $("#cellColorHex").val()
    var titleColor = $("#titleColorHex").val()
    var errorColor = $("#errorColorHex").val()
    var sizeTitle = $("#sizeTitle").val()
    var sizeError = $("#sizeError").val()
    var aceptColor = $("#aceptColorHex").val()
    var containerAceptColor = $("#containerAceptColorHex").val()
    var backgroundPickerColor = $("#backgroundPickerColorHex").val()
    var align = document.getElementById("selectTypeAlign").value;
    var font = document.getElementById("selectTypeFont").value;    
    var imageMandatory = $("#imageMandatory").val()
    var isEditing = $('#isEditingTextField').is(':checked');
    var isHidden = $('#isEditingTextField').is(':checked');

    console.log(imageMandatory);

    if (font == "custom") {
        font = $("#custonFont").val()
    }
    
    if (error.length == 0) {
        error = "error_generic_field"
    }

    if (controlError(title,keyTextField,font,sizeTitle,sizeError)) {
        if (allPickerIsComplete()) {
            createPickerField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,align,font,imageMandatory,isEditing, isHidden);
            savePickerField(keyTextField,"picker",title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,aceptColor,containerAceptColor,backgroundPickerColor,acceptButtonTextField,align,font,imageMandatory, isEditing, isHidden);
        }
        else {
            alert("Los campos de clave y valor de los picker deben estar todos rellenos");
        }
    }
}

window.allPickerIsComplete = function allPickerIsComplete() {
    var isComplete = true
    if (idPickerField == 0) {
        isComplete = false
    }
    for (var i = 0 ; i < idPickerField; i++) {
        var picker = $("#containerPickerField"+i)
        if (picker) {
            var key = $("#inputKeyPickerField"+i).val()
            var value = $("#inputValuePickerField"+i).val()
            if (key != null && value != null) {
                if (key.length == 0 || value.length == 0) {
                    isComplete = false
                }
            }
        }
    }
    return isComplete
}

//=== BOOLEAN ===
window.validateBooleanField = function validateBooleanField() {
    var keyTextField = $("#keyTextField").val()
    var title = $("#titleTextField").val()
    var error = $("#errorTextField").val()
    var mandatory = $('#mandatory').is(':checked');
    // Style
    var cellColor = $("#cellColorHex").val()
    var titleColor = $("#titleColorHex").val()
    var errorColor = $("#errorColorHex").val()
    var sizeTitle = $("#sizeTitle").val()
    var sizeError = $("#sizeError").val()
    var align = document.getElementById("selectTypeAlign").value;
    var font = document.getElementById("selectTypeFont").value;
    var imageMandatory = $("#imageMandatory").val()
    var imageCheckBoxOn = $("#imageCheckBoxOn").val()
    var imageCheckBoxOff = $("#imageCheckBoxOff").val()
    var isEditing = $('#isEditingTextField').is(':checked');
    var isHidden = $('#isEditingTextField').is(':checked');

    if (font == "custom") {
        font = $("#custonFont").val()
    }
    
    if (error.length == 0) {
        error = "error_generic_field"
    }
    
    if (controlError(title,keyTextField,font,sizeTitle,sizeError)) {
        createBooleanField(keyTextField,title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff,isEditing, isHidden);
        saveBooleanField(keyTextField,"boolean",title,error,mandatory,cellColor,titleColor,errorColor,sizeTitle,sizeError,align,font,imageMandatory,imageCheckBoxOn,imageCheckBoxOff,isEditing, isHidden)
    }
}

//=== INDEX ===
window.validateIndexField = function validateIndexField() {
    var keyTextField = $("#keyTextField").val()
    var title = $("#titleTextField").val()
    // Style
    var cellColor = $("#cellColorHex").val()
    var titleColor = $("#titleColorHex").val()
    var sizeTitle = $("#sizeTitle").val()
    var align = document.getElementById("selectTypeAlign").value;
    var font = document.getElementById("selectTypeFont").value;
    
    if (font == "custom") {
        font = $("#custonFont").val()
    }
    
    if (controlError(title,keyTextField,font,sizeTitle,10)) {
        createIndexField(keyTextField,title,cellColor,titleColor,sizeTitle,align,font);
        saveIndexField(keyTextField,"index",title,cellColor,titleColor,sizeTitle,align,font)
    }
}


/***/ }),
/* 13 */
/***/ (function(module, exports) {

module.exports = "  <div class=\"cellConstructor\" id=\"createField\">\n     <div class=\"row\">\n         <div class=\"col-md-10\">\n            <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\">\n            </div>         \n             <div class=\"containerTextFieldTop\">\n                 <div class=\"titleTextField\">\n                     <p>Titulo*:</p>\n                     <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\">\n                  </div>         \n             </div>\n             <div class=\"containerTextFieldCenter optionalBooleanContainer\">\n                  <div class=\"mandatoryTextField\">\n                     <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\">\n                     <p>Es obligatorio?</p>\n                  </div>\n                  \n                  <div class=\"isEditingTextField\">\n                      <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\">\n                      <p>Es editable?</p>\n                  </div>\n                  \n                 <div class=\"isHiddenTextField\">\n                     <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\">\n                     <p>Es visible?</p>\n                  </div>\n             </div>\n             <div class=\"errorTextField\">\n                 <p class=\"textErrorP\">Texto error:</p>\n                 <input type=\"text\" name=\"errorTextField\"id=\"errorTextField\">\n              </div>\n              <div class=\"styleField\"> \n                <h4>Estilos de celda:</h4>\n                                 \n                 <div class=\"sizeZone\">\n                    <p>Tamaño titulo:</p>\n                    <input id=\"sizeTitle\" type=\"text\" name=\"element\">\n                    <p>Tamaño texto error:</p>\n                    <input id=\"sizeError\" type=\"text\" name=\"element\">\n                 </div>\n                 \n                 {{htmlFont}}\n                 {{htmlImage}}\n\n                  <div class=\"colorZone\">\n                    {{colorBasicZone}}\n                 </div>  \n              </div>\n              <div class=\"spaceSeparate\"></div>\n         </div>\n         <div class=\"col-md-2 buttonAdd\" onclick=\"addField()\">\n             <p>+</p>\n         </div>\n     </div>\n </div>\n";

/***/ }),
/* 14 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor pickerConstructor\" id=\"createField\">\n   <div class=\"row\">\n       <div class=\"col-md-10\">\n            <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\">\n            </div>\n           <div class=\"containerTextFieldTop\">\n               <div class=\"titleTextField\">\n                   <p>Titulo*:</p>\n                   <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\">                                       \n                </div>                                 \n           </div>\n           <div id=\"containerErrorMandatoryPicker\">\n                <div class=\"errorTextField errorTextFieldPicker\">\n                   <p class=\"textErrorP\">Texto error:</p>\n                   <input type=\"text\" name=\"errorTextField\" id=\"errorTextField\">\n                </div>\n\n           </div>  \n           \n           <div class=\"acceptButtonTextField\">\n               <p>Titulo aceptar picker:</p>\n               <input type=\"text\" name=\"acceptButtonTextField\" id=\"acceptButtonTextField\">                                       \n            </div>  \n            \n           <div class=\"minAgeContainer\">\n               <p>Edad minima:</p>\n               <input type=\"text\" name=\"minAgeContainer\" id=\"minAgeContainer\">                                       \n            </div>  \n\n  \n\n            <div id=\"containerOptionalDatePicker\">\n                <div class=\"isHiddenTextField\">\n                   <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\">\n                   <p>Es visible?</p>\n                </div>\n                <div class=\"isEditingTextField\">\n                   <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\">\n                   <p>Es editable?</p>\n                </div>\n                <div class=\"mandatoryTextField optionModel\">\n                      <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\">\n                     <p>Es obligatorio?</p>\n                </div>                 \n            </div>\n\n\n\n\n            <div class=\"styleField\"> \n              <h4>Estilos de celda:</h4>\n               <div class=\"sizeZone\">\n                  <p>Tamaño titulo:</p>\n                  <input id=\"sizeTitle\" type=\"text\" name=\"element\">\n                  <p>Tamaño texto error:</p>\n                  <input id=\"sizeError\" type=\"text\" name=\"element\">\n               </div>\n\n                 {{htmlFont}}\n                 {{htmlImage}}\n\n                <div class=\"colorZone pickerColorZone\">\n                   <p>Color de la celda:</p>\n                    {{colorBasicZone}}\n\n                   <p class=\"nextColor\">Estilos picker selector</p>\n                   <p class=\"colorOKPicker\">Color texto OK:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"aceptColor\" class=\"cellColorCreate\"><input id=\"aceptColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n                   <p class=\"colorTittleP\">Color contenedor OK:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"containerAceptColor\" class=\"cellColorCreate\"><input id=\"containerAceptColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n                   <p class=\"colorTittleP\">Color fondo:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"backgroundPickerColor\" class=\"cellColorCreate\"><input id=\"backgroundPickerColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n\n               </div>\n            </div>\n            <div class=\"spaceSeparate\"></div>\n       </div>\n       <div class=\"col-md-2 buttonAdd buttonAddPicker\" onclick=\"addField()\">\n           <p>+</p>\n       </div>\n   </div>\n</div> \n\n";

/***/ }),
/* 15 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor\" id=\"createField\">\n    <div class=\"row\">\n        <div class=\"col-md-10\">\n            <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\">\n                    </div>\n            <div class=\"containerTextFieldTop\">\n                <div class=\"titleTextField\">\n                    <p>Titulo*:</p>\n                    <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\">\n                        </div>\n            </div>\n            <div class=\"styleField\">\n                <h4>Estilos de celda:</h4>\n                <div class=\"colorZone\">\n                    {{colorBasicZone}}\n                </div>\n                <div class=\"sizeZone\">\n                    <p>Tamaño titulo:</p>\n                    <input id=\"sizeTitle\" type=\"text\" name=\"element\">\n                </div>\n                \n                {{htmlFont}}\n            </div>\n            <div class=\"spaceSeparate\"></div>\n        </div>\n        <div class=\"col-md-2 buttonAdd\" onclick=\"addField()\">\n            <p>+</p>\n        </div>\n    </div>\n</div>\n\n\n\n";

/***/ }),
/* 16 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor pickerConstructor\" id=\"createField\">\n   <div class=\"row\">\n       <div class=\"col-md-10\">\n           <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\">\n           </div>\n           <div class=\"containerTextFieldTop\">\n               <div class=\"titleTextField\">\n                   <p>Titulo*:</p>\n                   <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\">                                       \n                </div>                                 \n           </div>\n           <div id=\"containerErrorMandatoryPicker\">\n                <div class=\"errorTextField errorTextFieldPicker\">\n                   <p class=\"textErrorP\">Texto error:</p>\n                   <input type=\"text\" name=\"errorTextField\" id=\"errorTextField\">\n                </div>\n           </div>  \n           \n           <div class=\"containerAcceptEditing\">\n               <div class=\"acceptButtonTextField\">\n                   <p>Titulo aceptar picker:</p>\n                   <input type=\"text\" name=\"acceptButtonTextField\" id=\"acceptButtonTextField\">\n               </div>\n           </div>\n\n\n           <div class=\"containerOptionalPicker\">           \n                <div class=\"mandatoryTextField optionModel\">\n                    <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\">\n                    <p>Es obligatorio?</p>\n                </div> \n\n               <div class=\"isEditingTextField\">\n                   <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\">\n                   <p>Es editable?</p>\n               </div>\n\n               <div class=\"isHiddenTextField\">\n                   <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\">\n                   <p>Es visible?</p>\n               </div>\n           </div>\n           \n\n           <div id=\"valuesOptionsSelector\"> \n              <div id=\"containerPickerFieldAdd\">\n                 <p id=\"addFieldPickerText\">Añadir campos del picker:</p> \n                 <div id=\"sumatoryPicker\">\n                      <p onclick=\"addContainerPicker()\">+</p>\n                </div>\n              </div>\n\n              <div id=\"pickerFieldsInsert\">\n                  <div class=\"containerPickerField\" id=\"containerPickerField'+idPickerField+'\">\n                      <input id=\"inputKeyPickerField0\" type=\"text\" name=\"element\" placeholder=\"Clave Picker\" value=\"KeyNoSelected\"  disabled readonly>\n                      <input id=\"inputValuePickerField0\" type=\"text\" name=\"element\" placeholder=\"Valor picker por defecto\">\n                  </div>\n              </div>\n            </div> \n\n            <div class=\"styleField\"> \n              <h4>Estilos de celda:</h4>\n               <div class=\"sizeZone\">\n                  <p>Tamaño titulo:</p>\n                  <input id=\"sizeTitle\" type=\"text\" name=\"element\">\n                  <p>Tamaño texto error:</p>\n                  <input id=\"sizeError\" type=\"text\" name=\"element\">\n               </div>\n               \n                 {{htmlFont}}\n                 {{htmlImage}}\n\n                <div class=\"colorZone pickerColorZone\">\n                    {{colorBasicZone}}\n\n                   <p class=\"nextColor\">Estilos picker selector</p>\n                   <p class=\"colorOKPicker\">Color texto OK:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"aceptColor\" class=\"cellColorCreate\"><input id=\"aceptColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n                   <p class=\"colorTittleP\">Color contenedor OK:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"containerAceptColor\" class=\"cellColorCreate\"><input id=\"containerAceptColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n                   <p class=\"colorTittleP\">Color fondo:</p>\n                   <input type=\"color\" value=\"#ffffff\" id=\"backgroundPickerColor\" class=\"cellColorCreate\"><input id=\"backgroundPickerColorHex\" class=\"inputColorHex\" placeholder=\"#ffffff\">\n               </div>\n            </div>\n            <div class=\"spaceSeparate\"></div>\n       </div>\n       <div class=\"col-md-2 buttonAdd buttonAddPicker\" onclick=\"addField()\">\n           <p>+</p>\n       </div>\n   </div>\n</div> \n\n\n                   \n";

/***/ }),
/* 17 */
/***/ (function(module, exports) {

module.exports = "\n   <div class=\"cellConstructor pickerConstructor\" id=\"fieldNumber{{indexField}}\">\n           <div class=\"row\">\n               <div class=\"col-md-10\">\n                   <div class=\"containerTextFieldTop\">\n                        <div class=\"keyTextField\">\n                            <p>key*:</p>\n                            <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\" value=\"{{keyTextField}}\" disabled readonly>\n                       </div>\n                         <div class=\"titleTextField\">\n                             <p>Titulo*:</p>\n                             <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\" value=\"{{title}}\" disabled readonly>                                       \n                          </div>                                 \n                   </div>\n\n                   <div id=\"containerErrorMandatoryPicker\">\n                        <div class=\"errorTextField errorTextFieldPicker\">\n                           <p class=\"textErrorP\">Texto error:</p>\n                           <input type=\"text\" name=\"errorTextField\" id=\"errorTextField\" disabled readonly value=\"{{error}}\">\n                        </div>   \n                   </div>   \n\n                 <div class=\"containerAcceptEditing\">\n                     <div class=\"acceptButtonTextField\">\n                         <p>Titulo aceptar picker:</p>\n                         <input type=\"text\" name=\"acceptButtonTextField\" id=\"acceptButtonTextField\" disabled readonly value=\"{{acceptButtonTextField}}\" >\n                     </div>\n                 </div>\n\n                   <div class=\"containerOptionalPicker\">    \n                     <div class=\"mandatoryTextField optionModel\">\n                              <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\" {{isMandatory}} disabled readonly>\n                             <p>Es obligatorio?</p>\n                        </div>                                    \n                        <div class=\"isEditingTextField\">\n                            <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\" {{isEditingChecked}} disabled readonly>\n                            <p>Es editable?</p>\n                        </div>\n\n                        <div class=\"isHiddenTextField\">\n                            <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\" {{isHiddenChecked}} disabled readonly>\n                            <p>Es visible?</p>\n                        </div>\n                   </div>\n\n                   <div id=\"valuesOptionsSelector\">     \n                      <div id=\"pickerFieldsInsert\">\n                          <p>Valores creados:</p>\n                          {{htmlPickerItems}}\n                      </div>\n                    </div> \n\n                  <div class=\"styleField\"> \n                      <h4>Estilos de celda:</h4>\n                        {{styles}}\n                  </div>\n                    <div class=\"spaceSeparate\"></div>\n               </div>\n               <div class=\"col-md-2 buttonRemove buttonAddPicker\" onclick=\"removeField({{indexField}})\">\n                  <p>-</p>\n               </div>\n           </div>\n      </div>\n";

/***/ }),
/* 18 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor\" id=\"createField\">\n     <div class=\"row\">\n         <div class=\"col-md-10\">\n             <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\">\n            </div>\n             <div class=\"containerTextFieldTop\">\n                 <div class=\"titleTextField\">\n                     <p>Titulo*:</p>\n                     <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\">\n                  </div>       \n                  <select id=\"selectTypeKeyboard\">\n                      <option value=\"None\">Elegir tipo de teclado</option>\n                      <option value=\"FormKeyboardTypeText\">Texto</option>\n                      <option value=\"FormKeyboardTypeEmail\">Email</option>\n                      <option value=\"FormKeyboardTypeNumbers\">Nuerico</option>\n                      <option value=\"FormKeyboardTypeNumberPad\">NuericoPad</option>\n                  </select>                                   \n             </div>\n             <div class=\"containerTextFieldCenter\">\n                 <div class=\"inputTextField\">\n                     <p>PlaceHolder:</p>\n                     <input type=\"text\" name=\"palceHolderTextField\" id=\"palceHolderTextField\">\n                 </div>\n             </div>\n             <div class=\"errorTextField\">\n                 <p class=\"textErrorP\">Texto error:</p>\n                 <input type=\"text\" name=\"errorTextField\" id=\"errorTextField\">\n              </div>\n             \n\n             <div class=\"compareTextField\">\n                 <input type=\"checkbox\" name=\"compare\" value=\"compare\" id=\"compare\">\n                 <p>Active compare?</p>\n                 <div id=\"containerCompare\">\n                     <p>Keys Compare:</p>\n                     <input type=\"text\" name=\"compareKeysField\" id=\"compareKeysField\" placeholder=\"key1,key2\">                 \n                     <div id=\"compareTextError\">\n                         <p>Texto error:</p>\n                         <input id=\"compareTextErrorInput\" type=\"text\" name=\"element\">\n                     </div>\n                 </div>\n            </div>\n\n\n             <div class=\"containerPassEdit\">\n                 <div class=\"passwordTextField\">\n                     <input type=\"checkbox\" name=\"passwordTextField\" value=\"passwordTextField\" id=\"passwordTextField\">\n                     <p>Es password?</p>\n                 </div>\n                 \n                 <div class=\"isEditingTextField\">\n                     <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\">\n                     <p>Es editable?</p>\n                  </div>\n                 \n                 <div class=\"isHiddenTextField\">\n                     <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\">\n                     <p>Es visible?</p>\n                  </div>\n\n                 <div class=\"mandatoryTextField\">\n                     <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\">\n                     <p>Es obligatorio?</p>\n                 </div>\n             </div>\n\n             <div class=\"validatorContainer\">\n                  <select id=\"selectTypeValidator\">\n                      <option value=\"None\">Tipo validador</option>\n                      <option value=\"text\">Texto</option>\n                      <option value=\"email\">Email</option>\n                      <option value=\"lengthText\">Long texto</option>\n                      <option value=\"numeric\">Numérico</option>\n                      <option value=\"postalCode\">Código postal</option>\n                      <option value=\"phone\">Teléfono</option>\n                      <option value=\"dniNie\">DNI/NIE</option>\n                      <option value=\"customValidator\">Custom</option>\n                  </select>  \n\n                  <input id=\"custonValidator\" placeHolder=\"Regex Custom\">    \n\n                  <div id=\"minMaxValidatorContainer\">\n                     <p>minLength:</p>\n                     <input class=\"inputWidth\" type=\"text\" name=\"minLength\"id=\"minLength\">\n                     <p>maxLength:</p>\n                     <input class=\"inputWidth\" type=\"text\" name=\"maxLength\"id=\"maxLength\">\n                  </div>\n\n                  <div id=\"validatorTextError\">\n                     <p>Texto error:</p>\n                     <input id=\"validatorTextErrorInput\" type=\"text\" name=\"element\">\n                  </div> \n             </div>\n             \n              <div class=\"styleField\">\n                   <h4>Estilos de celda:</h4>\n                        <div class=\"colorZone\">\n                        {{colorBasicZone}}\n                    </div>                                   \n                    <div class=\"sizeZone\">\n                        <p>Tamaño titulo:</p>\n                        <input id=\"sizeTitle\" type=\"text\" name=\"element\">\n                        <p>Tamaño texto error:</p>\n                        <input id=\"sizeError\" type=\"text\" name=\"element\">\n                    </div>\n\n                    {{htmlFont}}\n                    {{htmlImage}}\n              </div>\n              <div class=\"spaceSeparate\"></div>\n         </div>\n         <div class=\"col-md-2 buttonAdd\" onclick=\"addField()\">\n             <p>+</p>\n         </div>\n     </div>\n </div>";

/***/ }),
/* 19 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor\" id=\"fieldNumber{{indexField}}\">\n    <div class=\"row\">\n        <div class=\"col-md-10\">\n             <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\" disabled value=\"{{keyTextField}}\">\n            </div>\n            <div class=\"containerTextFieldTop\">\n                <div class=\"titleTextField\">\n                    <p>Titulo*:</p>\n                    <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\" disabled value=\"{{title}}\">\n                </div>\n                <div class=\"keyboardResult\">Keyboard:{{keyboard}}</div>\n            </div>\n            <div class=\"containerTextFieldCenter\">\n                <div class=\"inputTextField\">\n                    <p>PlaceHolder:</p>\n                    <input type=\"text\" name=\"palceHolderTextField\" id=\"palceHolderTextField\" disabled value=\"{{placeHolder}}\">\n                </div>                   \n            </div>\n            <div class=\"errorTextField\">        \n                <p class=\"textErrorP\">Texto error:</p>\n                <input type=\"text\" name=\"errorTextField\"id=\"errorTextField\" disabled value=\"{{error}}\"> \n            </div>\n\n            \n            <div class=\"compareTextField\">\n                <input type=\"checkbox\" name=\"compare\" value=\"compare\" id=\"compare\" {{isCompareChecked}} disabled readonly>\n                <p>Active compare?</p>\n                {{htmlTextErrorCompare}}\n            </div>\n\n            \n            \n            <div class=\"containerPassEdit\">\n                <div class=\"passwordTextField\">\n                    <input type=\"checkbox\" name=\"passwordTextField\" value=\"passwordTextField\" id=\"passwordTextField\" {{isPasswordChecked}} disabled readonly>\n                    <p>Es password?</p>\n                </div>\n                \n                <div class=\"isEditingTextField\">\n                    <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\" {{isEditingChecked}} disabled readonly>\n                    <p>Es editable?</p>\n                </div>\n                \n                <div class=\"isHiddenTextField\">\n                    <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\" {{isHiddenChecked}} disabled readonly>\n                    <p>Es visible?</p>\n                </div>\n\n                <div class=\"mandatoryTextField\">\n                    <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\" {{isMandatory}} disabled readonly>\n                    <p>Es obligatorio?</p>\n                </div>\n            </div>\n            \n\n            <div class=\"validatorContainer validatorCreated\">\n                <div class=\"validatorResult resultCreated\">Validator:{{validator}} {{htmlCustomValidator}}</div>  \n\n                {{htmlTextErrorValidator}}\n            </div>\n           \n            \n            <div class=\"styleField\"> \n                <h4>Estilos de celda:</h4>\n                {{styles}}\n            </div>\n            <div class=\"spaceSeparate\"></div>\n        </div>\n        <div class=\"col-md-2 buttonRemove buttonRemoveText\" onclick=\"removeField({{indexField}})\"><p>-</p></div>\n    </div>\n</div> \n\n";

/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

/* PASOS: Arrancar desde la ruta donde esta webpack.config.js y abrir consola y poner: npm start  */

window.Clipboard = __webpack_require__(0)
__webpack_require__(1)
__webpack_require__(6)
__webpack_require__(3)
__webpack_require__(7)
__webpack_require__(5)
__webpack_require__(12)
__webpack_require__(11)
__webpack_require__(10)
__webpack_require__(4)
__webpack_require__(2)
__webpack_require__(8)
__webpack_require__(9)

/***/ }),
/* 21 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor pickerConstructor\" id=\"fieldNumber{{indexField}}\">\n    <div class=\"row\">\n        <div class=\"col-md-10\">\n            <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\" disabled value=\"{{keyTextField}}\">\n            </div>\n            <div class=\"containerTextFieldTop\">\n                <div class=\"titleTextField\">\n                    <p>Titulo*:</p>\n                    <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\" value=\"{{title}}\" disabled readonly>\n                </div>\n            </div>\n            <div id=\"containerErrorMandatoryPicker\">\n                <div class=\"errorTextField errorTextFieldPicker\">\n                    <p class=\"textErrorP\">Texto error:</p>\n                    <input type=\"text\" name=\"errorTextField\" id=\"errorTextField\" disabled readonly value=\"{{error}}\">\n                </div>\n\n            </div>\n            \n           <div class=\"acceptButtonTextField\">\n               <p>Titulo aceptar picker:</p>\n               <input type=\"text\" name=\"acceptButtonTextField\" id=\"acceptButtonTextField\" value=\"{{acceptButtonTextField}}\">                                       \n            </div>  \n            \n            <div class=\"minAgeContainer versionCreatedMinAge datePickerMinAge\">\n                <p>Edad minima:</p>\n                <input type=\"text\" name=\"minAgeContainer\" id=\"minAgeContainer\" value=\"{{minAgeContainer}}\" disabled readonly>\n            </div>\n\n\n            <div id=\"containerOptionalDatePicker\">\n                <div class=\"mandatoryTextField optionModel datePickerMandatory\">\n                    <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\"{{isMandatory}} disabled readonly>\n                    <p>Es obligatorio?</p>\n                        </div>\n                <div class=\"isEditingTextField\">\n                    <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\" {{isEditingCheck}} disabled readonly>\n                        <p>Es editable?</p>\n                        </div>\n                        \n                <div class=\"isHiddenTextField\">\n                    <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\" {{isHiddenChecked}} disabled readonly>\n                    <p>Es visible?</p>\n                </div>\n            </div>\n\n\n            <div class=\"styleField\">\n                <h4>Estilos de celda:</h4>\n                {{styles}}\n            </div>\n            <div class=\"spaceSeparate\"></div>\n        </div>\n        <div class=\"col-md-2 buttonRemove buttonAddPicker\"onclick=\"removeField({{indexField}})\">\n            <p>-</p>\n        </div>\n    </div>\n </div>\n";

/***/ }),
/* 22 */
/***/ (function(module, exports) {

module.exports = "\n<div class=\"cellConstructor\" id=\"fieldNumber{{indexField}}\">\n    <div class=\"row\">\n        <div class=\"col-md-10\">\n             <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\" disabled value=\"{{keyTextField}}\">\n            </div>\n            <div class=\"containerTextFieldTop\">\n                <div class=\"titleTextField\">\n                    <p>Titulo*:</p>\n                    <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\" disabled value=\"{{title}}\">\n                </div>\n            </div>\n            <div class=\"containerTextFieldCenter optionalBooleanContainer\">\n                <div class=\"mandatoryTextField\">\n                    <input type=\"checkbox\" name=\"mandatory\" value=\"mandatory\" id=\"mandatory\" {{isMandatory}} disabled readonly >\n                    <p>Es obligatorio?</p>\n                </div>\n                <div class=\"isEditingTextField\">\n                    <input type=\"checkbox\" name=\"isEditingTextField\" value=\"isEditingTextField\" id=\"isEditingTextField\" {{isEditingValueCheck}} disabled readonly >\n                    <p>Es editable?</p>\n                </div>\n\n                <div class=\"isHiddenTextField\">\n                    <input type=\"checkbox\" name=\"isHiddenTextField\" value=\"isHiddenTextField\" id=\"isHiddenTextField\" {{isHiddenChecked}} disabled readonly>\n                    <p>Es visible?</p>\n                </div>\n            </div>\n            <div class=\"errorTextField\">\n                <p class=\"textErrorP\">Texto error:</p>\n                <input type=\"text\" name=\"errorTextField\"id=\"errorTextField\" disabled value=\"{{error}}\">\n            </div>\n            <div class=\"styleField\"> \n                <h4>Estilos de celda:</h4>\n                {{styles}} \n            </div>\n            <div class=\"spaceSeparate\"></div>\n        </div>\n        <div class=\"col-md-2 buttonRemove buttonRemoveText\" onclick=\"removeField({{indexField}})\"><p>-</p></div>\n    </div>\n</div> \n";

/***/ }),
/* 23 */
/***/ (function(module, exports) {

module.exports = "<div class=\"cellConstructor\" id=\"fieldNumber{{indexField}}\">\n    <div class=\"row\">\n        <div class=\"col-md-10\">\n            <div class=\"keyTextField\">\n                <p>key*:</p>\n                <input type=\"text\" name=\"keyTextField\" id=\"keyTextField\" disabled value=\"{{keyTextField}}\">\n            </div>\n            <div class=\"containerTextFieldTop\">\n                <div class=\"titleTextField\">\n                    <p>Titulo*:</p>\n                    <input type=\"text\" name=\"titleTextField\" id=\"titleTextField\" disabled value=\"{{title}}\">\n                </div>\n            </div>\n\n            <div class=\"styleField\">\n                <h4>Estilos de celda:</h4>\n                {{styles}}\n            </div>\n            <div class=\"spaceSeparate\"></div>\n        </div>\n        <div class=\"col-md-2 buttonRemove buttonRemoveText\" onclick=\"removeField({{indexField}})\"><p>-</p></div>\n    </div>\n</div> ";

/***/ })
/******/ ]);