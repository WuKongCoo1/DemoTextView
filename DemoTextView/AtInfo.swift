//
//  AtInfo.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/20.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit

class AtInfo: AttributeInfoProtocol {
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: url)
        
        guard let range = url.amendRange(), url.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20), range: range)
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
    
    func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? AtInfo else {
            return false
        }
        
        if other === self {
            return true
        }
        
        if other.url == self.url
        && other.infoA == self.infoA
        && other.infoB == self.infoB
        && other.id == self.id {
            return true
        }
        
        return false
    }
    
    init(url: String, infoA: Int?, infoB: Int?) {
        self.url = url
        self.infoA = infoA
        self.infoB = infoB
        super.init()
    }
}

