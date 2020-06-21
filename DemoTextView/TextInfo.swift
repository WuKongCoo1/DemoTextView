//
//  TextInfo.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/20.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit

final class TextInfo: AttributeInfoProtocol {
    var attributeString: NSAttributedString {
        let resultString = NSMutableAttributedString(string: text)
        
        guard let range = text.amendRange(), text.count != 0 else {
            return resultString
        }
        
        resultString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20), range: range)
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
    
    func isEqual(_ object: Any?) -> Bool {
        guard (object as? TextInfo) != nil else {
            return false
        }
        
        return true
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
        super.init()
    }
    
    /// 用将other的text和self的text拼起来
    /// - Parameter other: 前一个textInfo
    func reduce(_ other: Any?) {
        if let other = other as? TextInfo {
            self.text = "\(other.text)\(self.text)"
        }
    }
    
    func update(_ string: String) {
        self.text = string
    }
    
    func copy() -> TextInfo {
        let copy = TextInfo(text: self.text)
        copy.id = self.id
        return copy
    }
}
