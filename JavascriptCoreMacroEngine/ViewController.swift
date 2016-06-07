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


class ViewController: UIViewController, ProgressUpdate {

    @IBOutlet weak var innerRingView: CustomProgressView!
    @IBOutlet weak var middleRingView: CustomProgressView!
    @IBOutlet weak var outerRingView: CustomProgressView!
    @IBOutlet weak var codeView: CodeView!

    private var evenMore: MacroMethod?
    private var moreFunction: MacroMethod?
    private var evenLess: MacroMethod?
    private var lessFunction: MacroMethod?

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
        evenLess?.call()
        codeView.text = evenLess?.javascript
    }


    @IBAction func lessButton(sender: UIButton) {
        lessFunction?.call()
        codeView.text = lessFunction?.javascript
    }


    @IBAction func moreButton(sender: UIButton) {
        moreFunction?.call()
        codeView.text = moreFunction?.javascript
    }


    @IBAction func evenMoreButton(sender: UIButton) {
        evenMore?.call()
        codeView.text = evenMore?.javascript
    }

    func registerJavascriptMethods() {
        evenLess = loadJavascriptFile("evenLess")
        lessFunction = loadJavascriptFile("less")
        evenMore = loadJavascriptFile("evenMore")
        moreFunction = loadJavascriptFile("more")
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
    
    @IBAction func editButton(sender: UIButton) {
    }
    
    private func loadJavascriptFile(key: String) -> MacroMethod {
        guard let filePath = NSBundle.mainBundle().pathForResource(key, ofType: "js") else {
            print("Unable to load javascript file \(key).js")
            fatalError()
        }
        
        let script = try! String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        
        return MacroMethod(javascript: script, key: key)
    }
}

