//
//  DMAttributedStringDecorator.swift
//  DinerMojo
//
//  Created by Jaroslav Chaninovicz on 18/07/2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import Foundation


class DMAttributedStringDecorator: NSObject {
    
    static func attributedStrings(fullString: String, boldStrings : [String], font : UIFont, boldFont : UIFont, color : UIColor = .black, boldColor : UIColor = .black)-> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullString)
        let range = NSMakeRange(0, (fullString as NSString).length)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        
        for boldString in boldStrings {
            applyAttributedStringForAllOccurancesOfString(fullContent: fullString, word: boldString.lowercased(), attributedString: attributedString, font: boldFont, color: boldColor, range: nil)
        }
        
        return attributedString
    }
    
    private static func applyAttributedStringForAllOccurancesOfString(fullContent: String, word : String, attributedString: NSMutableAttributedString, font: UIFont, color : UIColor, range: Range<String.Index>?) {
        
        if let boldRange = fullContent.lowercased().range(of: word.trimmingCharacters(in: .newlines), options: .forcedOrdering, range: range, locale: nil) {
            
            let textBeforeWord = fullContent.substring(with: fullContent.startIndex..<boldRange.lowerBound) as NSString
            let realBoldRange = NSMakeRange(textBeforeWord.length, (word as NSString).length)
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: realBoldRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: realBoldRange)
            
            let end = fullContent.endIndex
            let start = boldRange.upperBound
            let newRange = start..<end
            
            applyAttributedStringForAllOccurancesOfString(fullContent: fullContent, word: word, attributedString: attributedString, font: font, color: color, range: newRange)
        }
    }
}
