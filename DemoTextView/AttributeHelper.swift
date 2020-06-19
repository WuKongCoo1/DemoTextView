//
//  AttributeHelper.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/19.
//  Copyright © 2020 bytedance. All rights reserved.


import Foundation

extension String {
    func amendRange() -> NSRange? {
        let r1 = self.range(of: self)
        if let tR1 = r1 {
            let n1 = NSRange(tR1, in: self)
            return n1
        }
        return nil
    }
}

extension NSRange {
    func isContinuous(_ range: NSRange) -> Bool{
        return self.location + self.length == range.location
    }
}

class AttributeHelper {
    class func convertAttributeStringToInfos(_ attributeString: NSAttributedString) -> [AttributeInfoProtocol] {
        var result = [AttributeInfoProtocol]()
        guard let range = attributeString.string.amendRange() else {
           return result
        }
        
        var prevAttribute: AttributeInfoProtocol!
        var prevRange: NSRange = NSRange(location: 0, length: 0)
        var isNeedRemoveLastItem = false
        attributeString.enumerateAttributes(in: range, options: []) { (attributes, atRange, stop) in
            guard let attribute = getAttributeInfo(attributes) else {
                return
            }
            
            guard prevAttribute != nil else {
                prevRange = atRange
                prevAttribute = attribute
                return
            }
            
            print("\(attributeString.attributedSubstring(from: atRange))")
            
            if prevAttribute.isEqual(attribute) && prevRange.isContinuous(atRange) {
                isNeedRemoveLastItem = true
            }
            
            if isNeedRemoveLastItem && result.count != 0 {
                result.removeLast()
            }
            
            result.append(attribute)
            
            prevRange = atRange
            prevAttribute = attribute
            isNeedRemoveLastItem = false
        }        
        return result
    }
    
    static let attributeKeys: [NSAttributedString.Key] = [AttributeKey.AttributeAtKey, AttributeKey.AttributeExternalLinkKey, AttributeKey.AttributeInternalLinkKey, AttributeKey.AttributeTextKey]
    
    class func getAttributeInfo(_ attributes: [NSAttributedString.Key: Any]) -> AttributeInfoProtocol? {
        for key in AttributeHelper.attributeKeys {
            if let attribute = attributes[key] {
                return attribute as? AttributeInfoProtocol
            }
        }
        return nil
    }
}
