//
//  AttributeHelper.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/19.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit

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
    
    /// right concatenate left eg: self:(1, 3) concatenate left:(0, 1) -> (0, 4)
    /// - Parameter left: left range
    mutating func concatenateRange(_ left: NSRange) {
        if left.location + left.length > location + length {
            return
        }
        
        if left.location + left.length < location {
            return
        }
        
        length = location + length - left.location
        self.location = left.location
//      length = (rightMax - leftMax) + (leftMax - rightMin) + (rightMin - leftMin)
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
            guard var attribute = getAttributeInfo(attributes) else {
                return
            }
            
            let currentText = attributeString.attributedSubstring(from: atRange).string
            //各个attribute可能指向的是同一个
            attribute = attribute.copy()
            attribute.update(currentText)
            
            guard prevAttribute != nil else {
                prevRange = atRange
                prevAttribute = attribute
                isNeedRemoveLastItem = false
                return
            }
            
            if prevAttribute.isEqual(attribute) && prevRange.isContinuous(atRange) {
                isNeedRemoveLastItem = true
                if prevAttribute.type == .text {
                    attribute.reduce(prevAttribute)
                }
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
    
    class func convertAttributeInfoToAttributeString(_ infos: [AttributeInfoProtocol]) -> NSAttributedString {
        let attributeString = NSMutableAttributedString()
        for attrInfo in infos {
            attributeString.append(attrInfo.attributeString)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        if let range = attributeString.string.amendRange() {
            attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        return attributeString
    }
    
    class func fixSelectRange(_ attributeString: NSAttributedString, targetRange: NSRange) -> NSRange {
        var fixRange = targetRange

        guard let range = attributeString.string.amendRange() else {
           return fixRange
        }

        var prevAttribute: AttributeInfoProtocol!

        attributeString.enumerateAttributes(in: range, options: []) { (attributes, atRange, stop) in
            guard let attribute = getAttributeInfo(attributes) else {
                return
            }

            let shoudStop = prevAttribute != nil && !prevAttribute.isEqual(attribute)
            if shoudStop {
                stop.pointee = true
                return
            }

            if fixRange.location >= atRange.location && fixRange.location + fixRange.length <= atRange.location + atRange.length {
                fixRange.location = atRange.location + atRange.length
                fixRange.length = 0
                prevAttribute = attribute
                return
            }
        }
        return fixRange
    }
    
    class func fixDeleteRange(_ attributeString: NSAttributedString, targetRange: NSRange) -> NSRange {
        var currentMaxRange: NSRange?
        guard let range = attributeString.string.amendRange() else {
           return targetRange
        }
        
        var prevAttribute: AttributeInfoProtocol?
        var didFound = false
                
        attributeString.enumerateAttributes(in: range, options: [.reverse]) { (attributes, atRange, stop) in
            print(attributeString.attributedSubstring(from: atRange).string)
            guard let attribute = getAttributeInfo(attributes) else {
                return
            }
            
            if let prevAttr = prevAttribute, prevAttr.isEqual(attribute) {
                currentMaxRange?.concatenateRange(atRange)
            } else {
                if let maxRange = currentMaxRange, targetRange.location >= maxRange.location && targetRange.location <= maxRange.location + maxRange.length {
                    stop.pointee = true
                    didFound = true
                    return
                }
                currentMaxRange = atRange
                prevAttribute = attribute
            }
        }
        
        if didFound == false, let maxRange = currentMaxRange, targetRange.location >= maxRange.location && targetRange.location <= maxRange.location + maxRange.length {//处理删除目标在第一个info中的情况
            didFound = true
        }
        
        if didFound {
            if prevAttribute?.type == .text {
                return targetRange
            }
            return currentMaxRange ?? targetRange
        }
        return targetRange
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
