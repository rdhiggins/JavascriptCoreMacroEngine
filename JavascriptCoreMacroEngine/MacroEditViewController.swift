//
// MacroEditViewController.swift
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

class MacroEditViewController: UIViewController {

    @IBOutlet weak var macroSelector: UISegmentedControl!
    @IBOutlet weak var codeView: CodeView!
    
    var macros: [MacroMethod] = []
    var lastSelectedIndex: Int = 0
    
    var delegate: MacroEditResults?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        macroSelector.selectedSegmentIndex = 0
        codeView.text = macros[0].javascript
        lastSelectedIndex = 0        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allDone(sender: AnyObject) {
        codeView.textView.resignFirstResponder()
        saveCurrentMacro()
        
        delegate?.results(macros)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func selectedMacro(sender: AnyObject) {
        codeView.textView.resignFirstResponder()
        
        saveCurrentMacro()
        lastSelectedIndex = macroSelector.selectedSegmentIndex
    }
    
    private func saveCurrentMacro() {
        macros[lastSelectedIndex].javascript = codeView.text!
        codeView.text = macros[macroSelector.selectedSegmentIndex].javascript
    }
}


protocol MacroEditResults {
    func results(macros: [MacroMethod])
}
