//: Playground - noun: a place where people can play

import UIKit
import GIGLibrary

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height:100))

label.textColor = UIColor.white
label.font = UIFont(name: "ChalkboardSE-Light", size: 15)
label.numberOfLines = 2

// MARK: Styled String Example

// MARK: Example 1

label.styledString = "Este es mi texto "
                    + "con estilo ".style(.bold,
                                          .underline,
                                          .underlineColor(UIColor.yellow))
                    + "rojo \n".style(.color(.red),
                                      .bold)
                    + "mola".style(.backgroundColor(UIColor.red))

label

// MARK: Example 2

label.styledString = "fuente 1 " + "fuente 2".style(.fontName("ArialMT"))

// MARK: Example 2

let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height:100))

let url = URL(string: "www.google.es")!
textView.attributedText = ("Pincha en este " + "link".style(.link(url))).toAttributedString(defaultFont: label.font)

// MARK: Example 2
var font = UIFont(name: "ArialMT", size: 15)!
label.font = font
label.styledString = "numero: " + "10".style(.size(50), .bold) + ".22".style(.size(20), .italic)

label.styledString = "Acepta los"
                    + " terminos y condiciones".style(.italic)
                    + " antes de recibir los"
                    + " 22".style(.size(20), .color(UIColor.red))
                    + ".35".style(.size(10), .color(UIColor.red))
                    + " Euros"

label

// MARK: HTML Example

// MARK: Example 1

label.html = "texto <b>importante</b>"

// MARK: Example 2

label.html = "texto <b style=\"color:red;\">importante</b>"
