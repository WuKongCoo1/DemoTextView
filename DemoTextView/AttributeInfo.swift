//
//  AttributeInfo.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/19.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit

enum AttributeType: Int {
    case internalLink = 1
    case externalLink = 2
    case at = 3
    case text = 4
}

protocol BaseAttributeProtocol {
    func attributeStringCore() -> NSAttributedString
}

typealias AttributeInfoProtocol = NSObject & BaseAttributeProtocol

let CustomAttributeKey = NSAttributedString.Key("customAttributeKey")

class AttributeInfo: NSObject, BaseAttributeProtocol {
    func attributeStringCore() -> NSAttributedString {
        return info.attributeStringCore()
    }
    
    let type: AttributeType = .text
    let info: AttributeInfoProtocol
    
    override func isEqual(_ object: Any?) -> Bool {
        assert(false, "you have to overwrite isEqual method")
        return false
    }
    
    init(info: AttributeInfoProtocol) {
        self.info = info
    }
}

class BaseInfo: AttributeInfoProtocol {
    internal func attributeStringCore() -> NSAttributedString {
        assert(false, "child have to overwrite attributeString method")
        return NSAttributedString()
    }
    
     final func attributeString() -> NSAttributedString {
        if let tAttrString = attributeStringCore().mutableCopy() as? NSMutableAttributedString, let range = tAttrString.string.amendRange() {
            tAttrString.addAttribute(CustomAttributeKey, value: self, range: range)
            return tAttrString
        }
        
        return attributeStringCore()
    }
}

class ExternalLinkInfo: AttributeInfoProtocol {
    func attributeStringCore() -> NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
        
        return resultString
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ExternalLinkInfo else {
            return false
        }
        
        if other === self {
            return true
        }
        
        if other.url == self.url
        && other.infoA == self.infoA
        && other.infoB == self.infoB {
            return true
        }
        
        return false
    }
    
    var url: String = ""
    var infoA: Int?
    var infoB: Int?
    
    init(url: String, infoA: Int?, infoB: Int?) {
        self.url = url
        self.infoA = infoA
        self.infoB = infoB
    }
    
}

class InternalLinkInfo: AttributeInfoProtocol {
    func attributeStringCore() -> NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        
        return resultString
    }
    
    var url: String = ""
    var infoA: Int?
    var infoB: Int?

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? InternalLinkInfo else {
            return false
        }
        
        if other === self {
            return true
        }
        
        if other.url == self.url
        && other.infoA == self.infoA
        && other.infoB == self.infoB {
            return true
        }
        
        return false
    }
    
    init(url: String, infoA: Int?, infoB: Int?) {
        self.url = url
        self.infoA = infoA
        self.infoB = infoB
    }
}

class AtInfo: AttributeInfoProtocol {
    func attributeStringCore() -> NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.cyan, range: range)
        
        return resultString
    }
    
    
    var url: String = ""
    var infoA: Int?
    var infoB: Int?
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? InternalLinkInfo else {
            return false
        }
        
        if other === self {
            return true
        }
        
        if other.url == self.url
        && other.infoA == self.infoA
        && other.infoB == self.infoB {
            return true
        }
        
        return false
    }
    
    init(url: String, infoA: Int?, infoB: Int?) {
        self.url = url
        self.infoA = infoA
        self.infoB = infoB
    }
}

class TextInfo: AttributeInfoProtocol {
    func attributeStringCore() -> NSAttributedString {
        let resultString = NSMutableAttributedString(string: text)
        
        guard let range = text.amendRange(), text.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        
        return resultString
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard (object as? TextInfo) != nil else {
            return false
        }
        
        return true
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
