//
// Thing.swift
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


/// Delegate protocol used to notify when a progress value has been updated
protocol ProgressUpdate {
    func innerProgressUpdate(_ progress: Float)
    func middleProgressUpdate(_ progress: Float)
    func outerProgressUpdate(_ progress: Float)
}



/// Class used to contain the progress values.  The class registers methods
/// with the MacroEngine that support setting the values through calling
/// Objective-C blocks.
class Thing: MacroEngineSupport {


    /// static proerty used to retrieve the one global instance of this class
    static var sharedInstance: Thing = Thing()


    /// property used for setting the delegate callback
    var delegate: ProgressUpdate?


    /// property containing the inner ring's progress value
    var innerProgress: Float {
        didSet {
            if innerProgress < 0.0 {
                innerProgress = 0
            } else if innerProgress > 10.0 {
                innerProgress = 10.0
            }

            delegate?.innerProgressUpdate(innerProgress)
        }
    }


    /// property containing the middle ring's progress value
    var middleProgress: Float {
        didSet {
            if middleProgress < 0.0 {
                middleProgress = 0.0
            } else if middleProgress > 10.0 {
                middleProgress = 10.0
            }

            delegate?.middleProgressUpdate(middleProgress)
        }
    }


    /// property containing the outer ring's progress value
    var outerProgress: Float {
        didSet {
            if outerProgress < 0.0 {
                outerProgress = 0.0
            } else if outerProgress > 10.0 {
                outerProgress = 10.0
            }

            delegate?.outerProgressUpdate(outerProgress)
        }
    }


    init(innerProgress: Float = 0.0, middleProgress: Float = 0.0, outerProgress: Float = 0.0) {
        self.innerProgress = innerProgress
        self.middleProgress = middleProgress
        self.outerProgress = outerProgress
        
        // Add to macro enginer
        MacroEngine.sharedInstance.addObject(self)
    }


    /// MacroEngine protocol method used to register the blocks used
    /// by javascript.
    ///
    /// - parameter engine: An instance of the MacroEngine class to
    /// register with
    func addMacroSupport(_ engine: MacroEngine) {
        engine.insertBlockAsObject(setInnerProgress, key: "setInnerProgress")
        engine.insertBlockAsObject(getInnerProgress, key: "getInnerProgress")
        
        engine.insertBlockAsObject(setMiddleProgress, key: "setMiddleProgress")
        engine.insertBlockAsObject(getMiddleProgress, key: "getMiddleProgress")
        
        engine.insertBlockAsObject(setOuterProgress, key: "setOuterProgress")
        engine.insertBlockAsObject(getOuterProgress, key: "getOuterProgress")
    }
}


// Javascript callbacks for getting/setting innerProgress
private let setInnerProgress: @convention(block) (Float) -> Void = { newValue in
    Thing.sharedInstance.innerProgress = newValue
}
private let getInnerProgress: @convention(block) (Void) -> Float = {
    return Thing.sharedInstance.innerProgress
}


// Javascript callbacks for getting/setting middleProgress
private let setMiddleProgress: @convention(block) (Float) -> Void = { newValue in
    Thing.sharedInstance.middleProgress = newValue
}
private let getMiddleProgress: @convention(block) (Void) -> Float = {
    return Thing.sharedInstance.middleProgress
}


// Javascript callbacks for getting/setting outerProgress
private let setOuterProgress: @convention(block) (Float) -> Void = { newValue in
    Thing.sharedInstance.outerProgress = newValue
}
private let getOuterProgress: @convention(block) (Void) -> Float = {
    return Thing.sharedInstance.outerProgress
}
