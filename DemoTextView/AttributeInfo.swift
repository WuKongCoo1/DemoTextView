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
    var attributeString: NSAttributedString { get }
    var type: AttributeType { get }
    var attributeKey: NSAttributedString.Key { get }
}

typealias AttributeInfoProtocol = NSObject & BaseAttributeProtocol

enum AttributeKey {
    static let AttributeInternalLinkKey = NSAttributedString.Key("AttributeInternalLinkKey")
    static let AttributeExternalLinkKey = NSAttributedString.Key("AttributeExternalLinkKey")
    static let AttributeAtKey = NSAttributedString.Key("AttributeAtKey")
    static let AttributeTextKey = NSAttributedString.Key("AttributeTextKey")
}

class BaseInfo: AttributeInfoProtocol {
    var attributeString: NSAttributedString {
        assert(false, "child have to overwrite attributeString method")
        return NSAttributedString()
    }
    
    var attributeKey: NSAttributedString.Key {
        return AttributeKey.AttributeTextKey
    }
    
    var type: AttributeType {
        return .text
    }
}

class ExternalLinkInfo: AttributeInfoProtocol {
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
        resultString.addAttribute(attributeKey, value: self, range: range)
        
        return resultString
    }
    
    var attributeKey: NSAttributedString.Key {
        return  AttributeKey.AttributeExternalLinkKey
    }
    
    var type: AttributeType {
        return .externalLink
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
    static var id: Int64 = 1
    var id: Int64
    
    init(url: String, infoA: Int?, infoB: Int?) {
        self.url = url
        self.infoA = infoA
        self.infoB = infoB
        self.id =
    }
    
}

class InternalLinkInfo: AttributeInfoProtocol {
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        resultString.addAttribute(attributeKey, value: self, range: range)
        return resultString
    }
    
    
    var attributeKey: NSAttributedString.Key {
        return AttributeKey.AttributeInternalLinkKey
    }
    
    var type: AttributeType {
        return .internalLink
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
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.cyan, range: range)
        resultString.addAttribute(attributeKey, value: self, range: range)
        return resultString
    }
    
    var attributeKey: NSAttributedString.Key {
        return  AttributeKey.AttributeAtKey
    }
    
    var type: AttributeType {
        return .at
    }
    
    
    var url: String = ""
    var infoA: Int?
    var infoB: Int?
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? AtInfo else {
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
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: text)
        
        guard let range = text.amendRange(), text.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range)
        resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        resultString.addAttribute(attributeKey, value: self, range: range)
        return resultString
    }
    
    
    var attributeKey: NSAttributedString.Key {
        return  AttributeKey.AttributeTextKey
    }
    
    var type: AttributeType {
        return .text
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
