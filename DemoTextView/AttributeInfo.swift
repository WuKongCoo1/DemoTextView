//
//  AttributeInfo.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/19.
//  Copyright © 2020 Personal. All rights reserved.


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
    func isEqual(_ object: Any?) -> Bool
    func update(_ string: String)
    func reduce(_ other: Any?)
    func copy() -> Self
}

extension BaseAttributeProtocol {
    func reduce(_ other: Any?) {
        
    }
    
    func update(_ string: String) {
        
    }
    
    func copy() -> Self {
        return self
    }
}

typealias AttributeInfoProtocol = BaseInfo & BaseAttributeProtocol

enum AttributeKey {
    static let AttributeInternalLinkKey = NSAttributedString.Key("AttributeInternalLinkKey")
    static let AttributeExternalLinkKey = NSAttributedString.Key("AttributeExternalLinkKey")
    static let AttributeAtKey = NSAttributedString.Key("AttributeAtKey")
    static let AttributeTextKey = NSAttributedString.Key("AttributeTextKey")
}

class BaseInfo {
    static var globleId: Int64 = 1
    internal var id: Int64
    
    init() {
        BaseInfo.globleId += 1
        self.id = BaseInfo.globleId
    }
}
