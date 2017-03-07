//
// MacroMethod.swift
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


import Foundation
import JavaScriptCore

/// Class that is used to implementing javascript methods.  Use an instance
/// to manage and execute a javascript method.
class MacroMethod {
    
    fileprivate let engine = MacroEngine.sharedInstance
    fileprivate var jsValue: JSValue!

    /// Property that contains the javascript method
    var javascript: String {
        didSet {
            setMethod()
        }
    }


    /// The name in the javascript context of the method
    let key: String
    
    
    init(javascript: String, key: String) {
        self.key = key
        self.javascript = javascript
        
        setMethod()
    }
    

    /// This method is used to invoke the javascript method.
    ///
    /// - parameter [params]:   The parameters for the javascript method.
    ///
    /// - return: A JSValue object result returned by the javascript
    /// method
    func call(_ params: AnyObject...) -> JSValue! {
        return jsValue.call(withArguments: params)
    }
    

    /// A private method used to configure the javascript method
    /// into the macro engine's context
    fileprivate func setMethod() {
        jsValue = engine.setMethod(javascript, key: key)
    }
}
