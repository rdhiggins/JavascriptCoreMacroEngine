//
// CodeView.swift
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

@IBDesignable
class CodeView: UIView {
    
    @IBInspectable var text: String? {
        set {
            textView?.text = newValue
        }
        get {
            return textView?.text
        }
    }

    @IBInspectable var gutterWidth: CGFloat = 40.0 {
        didSet {
            textView?.gutterWidth = gutterWidth
            layoutManager?.gutterWidth = gutterWidth
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
    
    @IBInspectable var font: UIFont? = UIFont.monospacedDigitSystemFontOfSize(14.0, weight: UIFontWeightThin) {
        didSet {
            textView?.font = font
            layoutManager?.font = font
        }
    }
    
    @IBInspectable var canEdit: Bool = true {
        didSet {
            textView?.editable = canEdit
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
        textView.editable = canEdit
        
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView?.frame = self.bounds
    }
}
