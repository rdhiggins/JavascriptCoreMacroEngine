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
    var textColor: UIColor = UIColor.white {
        didSet {
            setupFontAttributes()
        }
    }
    
    
    /// Property containing the width of the line number gutter
    var gutterWidth: CGFloat = 40.0

    /// Property containing the font to use for the line numbers
    var font: UIFont! =
        UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: UIFontWeightThin) {
        didSet {
            setupFontAttributes()
        }
    }

    
    fileprivate var fontAttributes: [String : NSObject] = [
        NSFontAttributeName :
            UIFont.monospacedDigitSystemFont(ofSize: 14.0,
                weight: UIFontWeightThin),
        NSForegroundColorAttributeName : UIColor.white
    ]

    
    /// Private method used to update the text color in the font
    /// attributes
    fileprivate func setupFontAttributes() {
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
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)

        // Enumerate over the lines that need refresh
        enumerateLineFragments(forGlyphRange: glyphsToShow) {
            rect, usedRect, textContainer, glyphRange, stop in

            let charRange = self.characterRange(forGlyphRange: glyphRange,
                                                        actualGlyphRange: nil)

            let before = (self.textStorage!.string as NSString)
                .substring(to: charRange.location)

            let lineNumber = before
                .components(
                    separatedBy: CharacterSet.newlines).count

            let r = CGRect(x: 0,
                           y: rect.origin.y,
                           width: self.gutterWidth,
                           height: rect.size.height)

            let gutterRect = r.offsetBy(dx: origin.x, dy: origin.y)
            let s = String(format: "%ld", lineNumber)
            let size = s.size(attributes: self.fontAttributes)
            let ds = gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width,
                                  dy: (gutterRect.height - size.height)
                                    / 2.0)

            s.draw(in: ds, withAttributes: self.fontAttributes)
        }
    }
}
