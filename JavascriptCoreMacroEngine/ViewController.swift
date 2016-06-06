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

class ViewController: UIViewController {

    @IBOutlet weak var innerRingView: CustomProgressView!
    @IBOutlet weak var middleRingView: CustomProgressView!
    @IBOutlet weak var outerRingView: CustomProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let thing = Thing.sharedInstance
        innerRingView.progress = CGFloat(thing.innerProgress)
        middleRingView.progress = CGFloat(thing.middleProgress)
        outerRingView.progress = CGFloat(thing.outerProgress)
        
        testScript()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func testScript() {
        let engine = MacroEngine.sharedInstance
        engine.context.evaluateScript("setInnerProgress(getInnerProgress() + 1.0)")
        engine.context.evaluateScript("setInnerProgress(getInnerProgress() + 1.0)")
        
        engine.context.evaluateScript("setMiddleProgress(getMiddleProgress() + 1.0)")
        engine.context.evaluateScript("setMiddleProgress(getMiddleProgress() + 1.0)")
        
        engine.context.evaluateScript("setOuterProgress(getOuterProgress() + 1.0)")
        engine.context.evaluateScript("setOuterProgress(getOuterProgress() + 1.0)")
    }
}

