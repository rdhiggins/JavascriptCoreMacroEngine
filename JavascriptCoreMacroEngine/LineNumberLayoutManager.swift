//
// LineNumberLayoutManager.swift
// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import UIKit


/// Custom layout manager class used to display line numbers for code.  The
/// gutter is on the left.  This class is used in conjunction with
/// LineNumberTextView class.  This class takes care of displaying the actual
/// line numbers.
class LineNumberLayoutManager: NSLayoutManager {

    /// Property containing the color to use for the text
    var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupFontAttributes()
        }
    }
    
    
    /// Property containing the width of the line number gutter
    var gutterWidth: CGFloat = 40.0

    /// Property containing the font to use for the line numbers
    var font: UIFont! = UIFont.monospacedDigitSystemFontOfSize(14.0, weight: UIFontWeightThin) {
        didSet {
            setupFontAttributes()
        }
    }

    
    private var fontAttributes: [String : NSObject] = [
        NSFontAttributeName : UIFont.monospacedDigitSystemFontOfSize(14.0, weight: UIFontWeightThin),
        NSForegroundColorAttributeName : UIColor.whiteColor()
    ]

    
    /// Private method used to update the text color in the font
    /// attributes
    private func setupFontAttributes() {
        fontAttributes = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName: textColor
        ]
    }

    
    /// Overridden method used to drawing the glyphs background.  Instead, we 
    /// figure out the line number for the glyph and draw that in the gutter.
    ///
    /// - parameter glyphsToShow: A range of the glyphs that need to updated
    /// - parameter atPoint: origin point
    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawBackgroundForGlyphRange(glyphsToShow, atPoint: origin)

        // Enumerate over the lines that need refresh
        enumerateLineFragmentsForGlyphRange(glyphsToShow) {
            rect, usedRect, textContainer, glyphRange, stop in

            let charRange = self.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)

            let before = (self.textStorage!.string as NSString).substringToIndex(charRange.location)
            let lineNumber = before.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).count

            let r = CGRect(x: 0, y: rect.origin.y, width: self.gutterWidth, height: rect.size.height)
            let gutterRect = CGRectOffset(r, origin.x, origin.y)
            let s = String(format: "%ld", lineNumber)
            let size = s.sizeWithAttributes(self.fontAttributes)
            let ds = CGRectOffset(gutterRect, CGRectGetWidth(gutterRect) - 4 - size.width, (CGRectGetHeight(gutterRect) - size.height) / 2.0)

            s.drawInRect(ds, withAttributes: self.fontAttributes)
        }
    }
}
