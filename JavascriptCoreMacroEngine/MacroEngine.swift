//
// MacroEngine.swift
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
import JavaScriptCore


/// Protocol used by the MacroEngine to setup the macro objects for a class.
protocol MacroEngineSupport {
    func addMacroSupport(engine: MacroEngine)
}


/// Class that manages the macro engine.  It has a static sharedInstance
/// property that should be used.
class MacroEngine {
    
    /// Static property for the one global instance of the MacroEngine
    static let sharedInstance: MacroEngine = MacroEngine()

    
    /// JavascriptCore context instance that the macro engine is using
    let context: JSContext = JSContext()

    
    init() {
        setupExceptionHandler()
    }
    
    
    /// Method used to add a object to the macro engine.  This method
    /// uses the MacroEngineSupport property to call the object's
    /// macro initialization method.
    ///
    /// - parameter object: Object supporting the MacroEngineSupport
    /// protocol
    func addObject(object: MacroEngineSupport) {
        object.addMacroSupport(self)
    }


    /// Call this method is inject a callback block into the javascript
    /// context.  This will allow any javascript code to call this block
    ///
    /// - parameter block:  Objective-C block
    /// - parameter key: String to use as the object name in the javascript
    /// context.
    func insertBlockAsObject<BlockType>(block: BlockType, key: String) {

        context.setObject(unsafeBitCast(block, AnyObject.self),
                          forKeyedSubscript: key)
    }


    /// This method is called to register a javascript method.  It returns the
    /// JSValue to use to call this method from swift.
    ///
    /// - parameter javascript: String containing the javascript for this
    /// method.
    /// - parameter key: String containing the joavascript context name
    func setMethod(javascript: String, key: String) -> JSValue! {
        let script = "var \(key) = \(javascript)"
        context.evaluateScript(script)
        
        return context.objectForKeyedSubscript(key)
    }


    /// Private method used to setup the exception handler.  The handler
    /// presents the error in a alert view
    private func setupExceptionHandler() {

        context.exceptionHandler = { context, error in
            let alert = UIAlertController(title: "Javascript Evaluation Error", message: error.toString(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

            UIApplication.sharedApplication()
                .keyWindow?
                .rootViewController?
                .presentedViewController?
                .presentViewController(alert,
                                       animated: true,
                                       completion: nil)
        }
    }
}
