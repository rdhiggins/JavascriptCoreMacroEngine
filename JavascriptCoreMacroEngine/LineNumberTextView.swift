//
// LineNumberTextView.swift
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


/// Custom UITextView class used to display code with line number gutter
/// on the left.  This class uses LineNumberLayoutManager to completely
/// present the line number.  This class presents the background for the
/// gutter
@IBDesignable
class LineNumberTextView: UITextView {

    /// property containing the fill coler to use for the gutter
    @IBInspectable
    var gutterFillColor: UIColor = UIColor.gray
    
    
    /// property containing the border color to use for the gutter
    @IBInspectable
    var gutterBorderColor: UIColor = UIColor.black
    
    
    /// property containing the strokeWidth to use for the gutter border
    @IBInspectable
    var gutterStrokeWidth: CGFloat = 0.5
    
    
    /// property containing the width to use for the gutter
    @IBInspectable
    var gutterWidth: CGFloat = 40.0
    
    
    /// property containing the color to use for the gutter number text
    @IBInspectable
    var gutterTextColor: UIColor = UIColor.black
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    
    /// private method used to configure the view.  It sets up a exclusion
    /// zone with the text container
    fileprivate func setup() {
        let bp = UIBezierPath(rect: CGRect(x: CGFloat(0.0),
                                 y: CGFloat(0.0),
                             width: gutterWidth,
                            height: CGFloat(FLT_MAX)))
        
        self.textContainer.exclusionPaths = [bp]
        self.contentMode = UIViewContentMode.redraw
    }
    
    
    /// drawRect method used to draw the gutter background.
    ///
    /// - parameter rect:   CGRect to refresh (ignored)
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let bounds = self.bounds
        
        context?.setFillColor(gutterFillColor.cgColor)

        context?.fill(CGRect(origin: bounds.origin,
                                 size: CGSize(width: gutterWidth,
                                              height: bounds.size.height)))

        context?.setStrokeColor(gutterBorderColor.cgColor)
        context?.setLineWidth(0.5)

        context?.stroke(CGRect(x: bounds.origin.x +
                                        (gutterWidth - gutterStrokeWidth),
                                   y: bounds.origin.y,
                                   width: gutterStrokeWidth,
                                   height: bounds.height))

        super.draw(rect)
    }
}
