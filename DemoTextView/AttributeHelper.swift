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

class AttributeHelper {
    class func convertAttributeStringToInfos(_ attributeString: NSAttributedString) -> [AttributeInfo] {
        let result = [AttributeInfo]()
        guard let range = attributeString.string.amendRange() else {
           return result
        }
        
        var prevAttribute = 
        attributeString.enumerateAttribute(CustomAttributeKey, in: range, options: [], using: { (attrbute, atRange, stop) -> Void in
            
        })
        
        return result
    }
}
