//
//  CodeView.swift
//  JavascriptCoreMacroEngine
//
//  Created by Rodger Higgins on 6/7/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import UIKit

@IBDesignable
class CodeView: UIView {
    
    @IBInspectable var text: String? {
        didSet {
            textView?.text = text
        }
    }

    @IBInspectable var gutterWidth: CGFloat = 40.0 {
        didSet {
            textView?.gutterWidth = gutterWidth
        }
    }
    
    @IBInspectable var gutterBorderWidth: CGFloat = 1.0 {
        didSet {
            textView?.gutterStrokeWidth = gutterBorderWidth
        }
    }
    
    @IBInspectable var gutterBackgroundColor: UIColor = UIColor.grayColor() {
        didSet {
            textView?.gutterFillColor = gutterBackgroundColor
        }
    }
    
    @IBInspectable var gutterTextColor: UIColor = UIColor.blackColor() {
        didSet {
            textView?.gutterTextColor = gutterTextColor
            layoutManager?.textColor = gutterTextColor
        }
    }
    
    @IBInspectable var gutterBorderColor: UIColor = UIColor.blackColor() {
        didSet {
            textView?.gutterBorderColor = gutterBorderColor
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        didSet {
            textView?.textColor = textColor
        }
    }
    
    @IBInspectable var font: UIFont? = UIFont.monospacedDigitSystemFontOfSize(10.0, weight: UIFontWeightThin) {
        didSet {
            textView?.font = font
            layoutManager?.font = font
        }
    }

    var textContainer: NSTextContainer!
    var layoutManager: LineNumberLayoutManager!
    var textStorage: NSTextStorage!
    var textView: LineNumberTextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    
    func setup() {
        textContainer = NSTextContainer()
        
        layoutManager = LineNumberLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        setupGutterRegion()
        setupTextView()
    }
    
    
    private func setupGutterRegion() {
        let bp = UIBezierPath(rect: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: gutterWidth, height: CGFloat(FLT_MAX)))
        
        self.textContainer.exclusionPaths = [bp]
    }
    
    
    private func setupTextView() {
        textView = LineNumberTextView(frame: self.bounds, textContainer: textContainer)
        textView.text = text
        textView.gutterFillColor = gutterBackgroundColor
        textView.gutterWidth = gutterWidth
        textView.gutterStrokeWidth = gutterBorderWidth
        textView.gutterBorderColor = gutterBorderColor
        textView.font = font
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false
        
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView?.frame = self.bounds
    }
}
