//
//  LineNumberTextView.swift
//  JavascriptCoreMacroEngine
//
//  Created by Rodger Higgins on 6/7/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import UIKit

@IBDesignable
class LineNumberTextView: UITextView {

    @IBInspectable
    var gutterFillColor: UIColor = UIColor.grayColor()
    
    @IBInspectable
    var gutterBorderColor: UIColor = UIColor.blackColor()
    
    @IBInspectable
    var gutterStrokeWidth: CGFloat = 0.5
    
    @IBInspectable
    var gutterWidth: CGFloat = 40.0
    
    @IBInspectable
    var gutterTextColor: UIColor = UIColor.blackColor()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    func setup() {
        let bp = UIBezierPath(rect: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: gutterWidth, height: CGFloat(FLT_MAX)))
        
        self.textContainer.exclusionPaths = [bp]
        self.contentMode = UIViewContentMode.Redraw
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let bounds = self.bounds
        
        CGContextSetFillColorWithColor(context, gutterFillColor.CGColor)
        CGContextFillRect(context, CGRect(origin: bounds.origin, size: CGSize(width: gutterWidth, height: bounds.size.height)))
        CGContextSetStrokeColorWithColor(context, gutterBorderColor.CGColor)
        CGContextSetLineWidth(context, 0.5)
        CGContextStrokeRect(context, CGRect(x: bounds.origin.x + (gutterWidth - gutterStrokeWidth), y: bounds.origin.y, width: gutterStrokeWidth, height: CGRectGetHeight(bounds)))

        super.drawRect(rect)
    }
}
