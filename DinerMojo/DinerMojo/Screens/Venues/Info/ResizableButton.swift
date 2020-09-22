//
//  ResizableButton.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 04.08.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation
import UIKit

class ResizableButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }
}
