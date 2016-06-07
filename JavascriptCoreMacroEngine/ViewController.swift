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

let jsEvenLess: String =
"var evenLess = function() {" +
"   var currentInner = getInnerProgress();" +
"   var currentMiddle = getMiddleProgress();" +
"   var currentOuter = getOuterProgress();" +
"" +
"   setInnerProgress(currentInner - Math.random());" +
"   setMiddleProgress(currentMiddle - Math.random());" +
"   setOuterProgress(currentOuter - Math.random());" +
"}"

let jsLess: String =
"var lessFunction = function() {" +
"   var currentInner = getInnerProgress();" +
"   var currentMiddle = getMiddleProgress();" +
"   var currentOuter = getOuterProgress();" +
"" +
"   setInnerProgress(currentInner - Math.random() / 10.0);" +
"   setMiddleProgress(currentMiddle - Math.random() / 10.0);" +
"   setOuterProgress(currentOuter - Math.random() / 10.0);" +
"}"

let jsEvenMore: String =
"var evenMore = function() {" +
"   var currentInner = getInnerProgress();" +
"   var currentMiddle = getMiddleProgress();" +
"   var currentOuter = getOuterProgress();" +
"" +
"   setInnerProgress(currentInner + Math.random());" +
"   setMiddleProgress(currentMiddle + Math.random());" +
"   setOuterProgress(currentOuter + Math.random());" +
"}"

let jsMore: String =
"var moreFunction = function() {" +
"   var currentInner = getInnerProgress();" +
"   var currentMiddle = getMiddleProgress();" +
"   var currentOuter = getOuterProgress();" +
"" +
"   setInnerProgress(currentInner + Math.random() / 10.0);" +
"   setMiddleProgress(currentMiddle + Math.random() / 10.0);" +
"   setOuterProgress(currentOuter + Math.random() / 10.0);" +
"}"



class ViewController: UIViewController, ProgressUpdate {

    @IBOutlet weak var innerRingView: CustomProgressView!
    @IBOutlet weak var middleRingView: CustomProgressView!
    @IBOutlet weak var outerRingView: CustomProgressView!

    private var evenMore: JSValue!
    private var moreFunction: JSValue!
    private var evenLess: JSValue!
    private var lessFunction: JSValue!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let thing = Thing.sharedInstance
        innerRingView.progress = CGFloat(thing.innerProgress)
        middleRingView.progress = CGFloat(thing.middleProgress)
        outerRingView.progress = CGFloat(thing.outerProgress)

        thing.delegate = self

        registerJavascriptMethods()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func evenLessButton(sender: UIButton) {
        evenLess.callWithArguments(nil)
    }


    @IBAction func lessButton(sender: UIButton) {
        lessFunction.callWithArguments(nil)
    }


    @IBAction func moreButton(sender: UIButton) {
        moreFunction.callWithArguments(nil)
    }


    @IBAction func evenMoreButton(sender: UIButton) {
        evenMore.callWithArguments(nil)
    }



    func registerJavascriptMethods() {
        let engine = MacroEngine.sharedInstance

        engine.context.evaluateScript(jsEvenLess)
        engine.context.evaluateScript(jsEvenMore)
        engine.context.evaluateScript(jsMore)
        engine.context.evaluateScript(jsLess)

        evenLess = engine.context.objectForKeyedSubscript("evenLess")
        lessFunction = engine.context.objectForKeyedSubscript("lessFunction")
        evenMore = engine.context.objectForKeyedSubscript("evenMore")
        moreFunction = engine.context.objectForKeyedSubscript("moreFunction")
    }

    func innerProgressUpdate(progress: Float) {
        innerRingView.progress = CGFloat(progress)
    }

    func middleProgressUpdate(progress: Float) {
        middleRingView.progress = CGFloat(progress)
    }

    func outerProgressUpdate(progress: Float) {
        outerRingView.progress = CGFloat(progress)
    }
}

