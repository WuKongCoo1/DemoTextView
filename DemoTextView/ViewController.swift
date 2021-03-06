//
//  ViewController.swift
//  DemoTextView
//
//  Created by 吴珂 on 2020/6/18.
//  Copyright © 2020 Personal. All rights reserved.


import UIKit


class ViewController: UIViewController {
    
    var lastRange = NSRange(location: 0, length: 0)
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
//        textView.addGestureRecognizer(tapGesture)
        
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byClipping
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .white
        test()
    }
//    🔴1🔴2🔴3内部文档1
    func test() {
        let internalLinkInfo1 = InternalLinkInfo(url: "123内部文档", infoA: 2, infoB: 3)
        let internalLinkInfo2 = InternalLinkInfo(url: "123内部文档1", infoA: 2, infoB: 3)
        let externalLinkInfo1 = ExternalLinkInfo(url: "www.baidu.com1", infoA: 2, infoB: 3)
        let externalLinkInfo2 = ExternalLinkInfo(url: "www.baidu.com1", infoA: 2, infoB: 3)
        let atInfo1 = AtInfo(url: "@jacky", infoA: 6, infoB: 7)
        let atInfo2 = AtInfo(url: "@jacky", infoA: 6, infoB: 7)
        let textInfo1 = TextInfo(text: "🔴🔴哈哈哈哈哈哈www.baidu.com")
        let textInfo2 = TextInfo(text: "🔴🔴哈哈哈哈哈哈www.baidu.com")
                
        let attrInfos: [AttributeInfoProtocol] = [internalLinkInfo1, internalLinkInfo2, externalLinkInfo1, externalLinkInfo2, atInfo1, textInfo1, atInfo2, textInfo2]

        textView.attributedText = AttributeHelper.convertAttributeInfoToAttributeString(attrInfos)
        
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
    
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {

        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager

        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;

        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {

            // print the character index
            print("character index: \(characterIndex)")

            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")

//            // check if the tap location has a certain attribute
//            let attributeName = NSAttributedString.Key.myAttributeName
//            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
//            if let value = attributeValue {
//                print("You tapped on \(attributeName.rawValue) and the value is: \(value)")
//            }

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test()
//        view.endEditing(true)
    }
}



extension ViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let currentSelectRange = textView.selectedRange
        if lastRange.location == currentSelectRange.location && lastRange.length == currentSelectRange.length {
            return
        }
        
        guard let attributeString = textView.attributedText else {
            return
        }
        
        let fixRange = AttributeHelper.fixSelectRange(attributeString, targetRange: currentSelectRange)
        lastRange = fixRange
        textView.selectedRange = fixRange
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let attributeString = textView.attributedText else {
            return true
        }
        if text.count == 0 {//删除
            let fixRange = AttributeHelper.fixDeleteRange(attributeString, targetRange: range)
            let tAttrString = NSMutableAttributedString(attributedString: attributeString)
            tAttrString.replaceCharacters(in: fixRange, with: "")
            textView.attributedText = tAttrString
            textView.selectedRange = NSRange(location: fixRange.location, length: 0)
            return false
        }
        
        return true
    }
}

