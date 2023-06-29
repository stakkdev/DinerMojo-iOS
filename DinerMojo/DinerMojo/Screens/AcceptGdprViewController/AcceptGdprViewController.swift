//
//  AcceptGdprViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 23.05.2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import UIKit

class AcceptGdprViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBAction func skipGdpr(_ sender: Any) {
        sendGdprRequest(accept: false)
    }
    
    @IBAction func acceptGdpr(_ sender: Any) {
        sendGdprRequest(accept: true)
    }
    
    private func sendGdprRequest(accept: Bool) {
        let userRequest = DMUserRequest()
        userRequest.sendGDPR(accept) { (_, _) in
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "http://dinermojo.com/privacy") else { return }
        let attrString = NSMutableAttributedString(string: NSLocalizedString("gdpr.desc1", comment: ""))
        let linkAttrString1 = NSMutableAttributedString(string: NSLocalizedString("gdpr.desc2", comment: ""))
        linkAttrString1.addAttribute(NSAttributedString.Key.link, value: url, range: NSRange(location: 0, length: linkAttrString1.length))
        attrString.append(linkAttrString1)
        let descAttrString2 = NSAttributedString(string: NSLocalizedString("gdpr.desc3", comment: ""))
        attrString.append(descAttrString2)
        let linkAttrString2 = NSMutableAttributedString(string: NSLocalizedString("gdpr.desc4", comment: ""))
        linkAttrString2.addAttribute(NSAttributedString.Key.link, value: url, range: NSRange(location: 0, length: linkAttrString2.length))
        attrString.append(linkAttrString2)
        attrString.append(NSAttributedString(string: "."))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                          convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.init(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0),
                          convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle) : paragraphStyle]
        attrString.addAttributes(convertToNSAttributedStringKeyDictionary(attributes), range: NSRange(location: 0, length: attrString.length))
        
        descTextView.isUserInteractionEnabled = true
        descTextView.isSelectable = true
        descTextView.isEditable = false
        descTextView.attributedText = attrString
        descTextView.delegate = self
        titleLabel.text = NSLocalizedString("gdpr.title", comment: "")
        skipButton.setTitle(NSLocalizedString("gdpr.skip", comment: ""), for: .normal)
        acceptButton.setTitle(NSLocalizedString("gdpr.gotIt", comment: ""), for: .normal)        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
}

extension AcceptGdprViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
