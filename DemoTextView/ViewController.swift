//
//  ViewController.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/18.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit


class ViewController: UIViewController {
    
    static let WKTestAttributeKeyExternalLink = NSAttributedString.Key("externalLink")
    static let WKTestAttributeKeyAt = NSAttributedString.Key("@")
    static let WKTestAttributeKeyText = NSAttributedString.Key("text")
    
    enum WKTestAttribute: String {
        case A = "internalLink"
        case B = "externalLink"
        case C = "@"
        case D = "text"
    }
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byClipping
        textView.dataDetectorTypes = .link
        
        let internalLinkInfo = InternalLinkInfo(url: "🔴1🔴2🔴3内部文档", infoA: nil, infoB: nil)
        let internalLinkAttrInfo = AttributeInfo(info: internalLinkInfo)
        
        let externalLinkInfo = ExternalLinkInfo(url: "www.baidu.com", infoA: nil, infoB: nil)
        let externalLinkAttrInfo = AttributeInfo(info: externalLinkInfo)
        
        let atInfo = AtInfo(url: "@jacky", infoA: nil, infoB: nil)
        let atAttrInfo = AttributeInfo(info: atInfo)
        
        let textInfo = TextInfo(text: "🔴🔴哈哈哈哈哈哈www.baidu.com")
        let textAttrInfo = AttributeInfo(info: textInfo)
                
        
        let attrInfos: [AttributeInfo] = [internalLinkAttrInfo, externalLinkAttrInfo, atAttrInfo, textAttrInfo]
        let attributeString = NSMutableAttributedString()
        for attrInfo in attrInfos {
            attributeString.append(attrInfo.attributeStringCore())
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        if let range = attributeString.string.amendRange() {
            attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        textView.attributedText = attributeString
    }
}

extension ViewController: UITextViewDelegate {
    
}

