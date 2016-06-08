//
//  LineNumberLayoutManager.swift
//  JavascriptCoreMacroEngine
//
//  Created by Rodger Higgins on 6/7/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import UIKit

class LineNumberLayoutManager: NSLayoutManager {

    var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupFontAttributes()
        }
    }

    var font: UIFont! = UIFont.monospacedDigitSystemFontOfSize(10.0, weight: UIFontWeightThin)

    private var fontAttributes: [String : NSObject] = [
        NSFontAttributeName : UIFont.monospacedDigitSystemFontOfSize(10.0, weight: UIFontWeightThin),
        NSForegroundColorAttributeName : UIColor.whiteColor()
    ]


    private func setupFontAttributes() {
        fontAttributes = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName: textColor
        ]
    }

    override func processEditingForTextStorage(textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditingForTextStorage(textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
    }


    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawBackgroundForGlyphRange(glyphsToShow, atPoint: origin)

        enumerateLineFragmentsForGlyphRange(glyphsToShow) {
            rect, usedRect, textContainer, glyphRange, stop in

            let charRange = self.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)

            let before = (self.textStorage!.string as NSString).substringToIndex(charRange.location)
            let lineNumber = before.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).count

            let r = CGRect(x: 0, y: rect.origin.y, width: 40.0, height: rect.size.height)
            let gutterRect = CGRectOffset(r, origin.x, origin.y)
            let s = String(format: "%ld", lineNumber)
            let size = s.sizeWithAttributes(self.fontAttributes)
            let ds = CGRectOffset(gutterRect, CGRectGetWidth(gutterRect) - 4 - size.width, (CGRectGetHeight(gutterRect) - size.height) / 2.0)

            s.drawInRect(ds, withAttributes: self.fontAttributes)
        }
    }
}
