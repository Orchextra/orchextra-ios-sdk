//
//  IndexFormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 10/1/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import UIKit

protocol PIndexFormField {
    func userDidTapLink(_ key: String)
}

class IndexFormField: FormField {

    @IBOutlet var indexLabel: FRHyperLabel!
    
    
    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.awakeFromNib(frame, classField: type(of: self))
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public Method
    
    override func insertData() {
        self.loadData(self.formFieldM!)
        self.loadCustomStyleField(self.formFieldM!)
    }
    
    
    // MARK: Actions
    
    func labelAction(grTap: UITapGestureRecognizer) {
        self.formFieldOutput?.userDidTapLink((self.formFieldM?.key)!)
    }
    
    
    // MARK: Private Method
    
    fileprivate func initializeView() {
        self.indexLabel.numberOfLines = 0
    }
    
    
    // MARK: Load data field
    
    fileprivate func loadData(_ formFieldM: FormFieldModel) {
        self.indexLabel.text = formFieldM.label
        
        if self.existLink(formFieldM.label!) {
            let getLinks = self.getListLinks(formFieldM.label!)
            
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
            self.indexLabel.attributedText = NSAttributedString(string: getLinks.1, attributes: attributes)
            
            //Step 2: Define a selection handler block
            let handler = {
                (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                if let key = substring {
                    self.formFieldOutput?.userDidTapLink(key)
                }
            }
            
            //Step 3: Add link substrings
            self.indexLabel.setLinksForSubstrings(getLinks.0, withLinkHandler: handler)
            self.indexLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    fileprivate func loadCustomStyleField(_ formFieldM: FormFieldModel) {
        let styleField = formFieldM.style
        if styleField != nil {
            if styleField!.backgroundColorField != nil {
                self.viewContainer.backgroundColor = styleField!.backgroundColorField!
            }
            if styleField!.titleColor != nil {
                self.indexLabel.textColor = styleField!.titleColor!
            }
            if styleField!.fontTitle != nil {
                self.indexLabel.font = styleField?.fontTitle
            }
            if styleField!.align != nil {
                self.indexLabel.textAlignment = styleField!.align!
            }
        }
    }
    
    
    // MARK: Parse
    
    fileprivate func existLink(_ text: String) -> Bool {
        // TODOE EDU otra opcion // return text.characters.index(of: "{") != nil
        if text.characters.index(of: "{") != nil {
            return true
        }
        return false
    }
    
    fileprivate func getListLinks(_ text: String) -> ([String], String) {
        let newStringKey = text.replacingOccurrences(of: "{* ", with: "{* #", options: .literal, range: nil)
        let firstPart = newStringKey.components(separatedBy: "{* ")
        let localizedStringPieces = self.separeteString(listPart: firstPart)
        
        var listLink = [String]()
        var allWords = ""
        for word in localizedStringPieces {
            if word.hasPrefix("#") {
                let link = word.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
                listLink.append(link)
                allWords += link
            } else {
                allWords += word
            }
        }
        
        return (listLink, allWords)
    }
    
    fileprivate func separeteString(listPart: [String]) -> [String] {
        var auxList = [String]()
        for text in listPart {
            let findPart = text.components(separatedBy: " *}")
            auxList += findPart
        }
        return auxList
    }
}
