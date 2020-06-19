//
//  ViewController.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/18.
//  Copyright © 2020 bytedance. All rights reserved.


import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byClipping
        textView.dataDetectorTypes = .link
        
        setup()
    }
    
    func setup() {
        let internalLinkInfo1 = InternalLinkInfo(url: "🔴1🔴2🔴3内部文档1", infoA: 2, infoB: 3)
        let internalLinkInfo2 = InternalLinkInfo(url: "🔴1🔴2🔴3内部文档1", infoA: 2, infoB: 3)
        let externalLinkInfo1 = ExternalLinkInfo(url: "www.baidu.com1", infoA: 2, infoB: 3)
        let externalLinkInfo2 = ExternalLinkInfo(url: "www.baidu.com1", infoA: 2, infoB: 3)
        let atInfo1 = AtInfo(url: "@jacky", infoA: 6, infoB: 7)
        let atInfo2 = AtInfo(url: "@jacky", infoA: 6, infoB: 7)
        let textInfo1 = TextInfo(text: "🔴🔴哈哈哈哈哈哈www.baidu.com")
        let textInfo2 = TextInfo(text: "🔴🔴哈哈哈哈哈哈www.baidu.com")
                
        let attrInfos: [AttributeInfoProtocol] = [internalLinkInfo1, internalLinkInfo2, externalLinkInfo1, externalLinkInfo2, atInfo1, atInfo2, textInfo1, textInfo2]
//        let attrInfos: [AttributeInfoProtocol] = [internalLinkInfo1, externalLinkInfo1, externalLinkInfo2, internalLinkInfo2, atInfo1, atInfo2, textInfo1, textInfo2]
        let attributeString = NSMutableAttributedString()
        for attrInfo in attrInfos {
            attributeString.append(attrInfo.attributeString)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        if let range = attributeString.string.amendRange() {
            attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        textView.attributedText = attributeString
        
        var isSuccess = true
        let convertResult = AttributeHelper.convertAttributeStringToInfos(textView.attributedText)
        if convertResult.count == attrInfos.count {
            for (index, convertInfo) in convertResult.enumerated() {
                let originalInfo = attrInfos[index]
                if !originalInfo.isEqual(convertInfo) {
                    isSuccess = false
                }
            }
        } else {
            isSuccess = false
        }
        
        if isSuccess {
            print("convert success")
        } else {
            print("convert Faield")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setup()
    }
}



extension ViewController: UITextViewDelegate {
    
}

