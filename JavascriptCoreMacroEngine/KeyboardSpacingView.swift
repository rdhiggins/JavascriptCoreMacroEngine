//
// KeyboardSpacingView.swift
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

/// This class uses autolayout to adjust for a keyboard appearing or 
/// disappearing.  It uses a height constrait to adjust its size to protect
/// a view from hiding controls behind a keyboard.  This will require the
/// view to be large enough to show all the controls once the keyboard is
/// displayed.
///
/// Place this view at the bottom of your storyboard with the proper constraints.
/// Place a height constraint of zero on it, but mark that constraint for
/// removal at build time.
class KeyboardSpacingView: UIView {
    
    /// property for the hieght constraint that we will set to different
    /// values when a view appears or disappears
    var heightConstraint: NSLayoutConstraint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    /// Private method for setting up this view.  It registers for the keyboard
    /// notifications, creates the height constraint, and sets the background
    /// color to clear so the does not show.
    private func setup() {
        registerKeyboardNotifications()
        
        heightConstraint = NSLayoutConstraint(item: self,
                                              attribute: .Height,
                                              relatedBy: .Equal,
                                              toItem: nil,
                                              attribute: .NotAnAttribute,
                                              multiplier: 1.0,
                                              constant: 0.0)
        self.addConstraint(heightConstraint)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    /// Private method for registering for keyboard notifications
    private func registerKeyboardNotifications() {
        addObserver(#selector(self.willShowKeyboard(_:)),
                    name: UIKeyboardWillShowNotification)
        
        addObserver(#selector(self.willHideKeyboard(_:)),
                    name: UIKeyboardWillHideNotification)
        
    }
    
    
    /// Private utility method for registering with the default
    /// notification center
    ///
    /// - parameter selector: The class method to connect to the notification
    /// - parameter name: The notification string to register for
    private func addObserver(selector: Selector, name: String) {
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self,
                           selector: selector,
                           name: name,
                           object: nil)
    }
    
    
    /// Will Show Keyboard notification handler.  This method decodes the
    /// notification information and then calculates the new value for
    /// the height constraint.
    ///
    /// - parameter notification: NSNotification
    func willShowKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(),
            let keyboardFrame = self.superview?.convertRect(keyboardEndFrame, fromView: self.window),
            let windowFrame = self.superview?.convertRect((self.window?.frame)!, fromView: self.window),
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval else {
            
            print("Not enough userInfo")
            fatalError()
        }
        
        let heightOffset = (windowFrame.size.height - keyboardFrame.origin.y) - self.superview!.frame.origin.y
        heightConstraint.constant = heightOffset
        UIView.animateWithDuration(duration) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    
    /// Will Hide Keyboard notification handler.  This method decodes the
    /// notification information for the animation duration. And then
    /// sets the height constraint to zero.
    ///
    /// - parameter notification: NSNotification
    func willHideKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval else {
            
            print("not enough userInfo")
            fatalError()
        }
        
        heightConstraint.constant = 0
        UIView.animateWithDuration(duration) {
            self.superview?.layoutIfNeeded()
        }
    }
}
