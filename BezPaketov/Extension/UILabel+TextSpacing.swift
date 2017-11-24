//
//  UILabel+TextSpacing.swift
//  BezPaketov
//
//  Created by Oleg on 8/13/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UILabel (Text Spacing)

extension UILabel {
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text!.characters.count))
        attributedText = attributedString
    }
}
