//
// ViewController.swift
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


/// The main view controller for the demo application
class ViewController: UIViewController, ProgressUpdate {

    @IBOutlet weak var innerRingView: CustomProgressView!
    @IBOutlet weak var middleRingView: CustomProgressView!
    @IBOutlet weak var outerRingView: CustomProgressView!
    @IBOutlet weak var codeView: CodeView!

    /// A private property containing the four MacroMethod objects used
    /// for the buttons to change the values of the progress indicators
    private var macros: [MacroMethod] = []

    private var javascriptFiles: [String] = [
        "evenLess",
        "less",
        "more",
        "evenMore"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the delegate
        let thing = Thing.sharedInstance
        thing.delegate = self

        registerJavascriptMethods()
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Get the current values of the progress indicators
        let thing = Thing.sharedInstance
        innerRingView.progress = CGFloat(thing.innerProgress)
        middleRingView.progress = CGFloat(thing.middleProgress)
        outerRingView.progress = CGFloat(thing.outerProgress)
    }


    /// IBAction used by the progress indicator buttons
    @IBAction func executeMacroButton(sender: UIButton) {

        // Call the javascript method
        macros[sender.tag].call()

        // Load the javascript for the button just executed
        codeView?.text = macros[sender.tag].javascript
    }
    

    /// A private method used to register the javascript methods
    /// with the macro engine
    private func registerJavascriptMethods() {
        for file in javascriptFiles {
            macros.append(loadJavascriptFile(file))
        }
    }


    /// ProgressUpdate protocol method called when the inner progress has 
    /// changed
    func innerProgressUpdate(progress: Float) {
        innerRingView.progress = CGFloat(progress)
    }


    /// ProgressUpdate protocol method called when the middle progress has
    /// changed
    func middleProgressUpdate(progress: Float) {
        middleRingView.progress = CGFloat(progress)
    }


    /// ProgressUpdate protocol method called when the outer progress 
    /// has changed
    func outerProgressUpdate(progress: Float) {
        outerRingView.progress = CGFloat(progress)
    }


    /// A private method that is called to load contents of the 
    /// javascript file included in the resource bundle of the application
    private func loadJavascriptFile(key: String) -> MacroMethod {
        guard let filePath = NSBundle.mainBundle().pathForResource(key, ofType: "js") else {
            print("Unable to load javascript file \(key).js")
            fatalError()
        }
        
        let script = try! String(contentsOfFile: filePath,
                                 encoding: NSUTF8StringEncoding)
        
        return MacroMethod(javascript: script, key: key)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMacros" {
            if let mevc = segue.destinationViewController
                as? MacroEditViewController {

                mevc.macros = macros
            }
        }
    }
}

