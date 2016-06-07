//
//  MacroEngine.swift
//  JavascriptCoreMacroEngine
//
//  Created by Rodger Higgins on 6/6/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import Foundation
import JavaScriptCore


protocol MacroEngineSupport {
    func addMacroSupport(engine: MacroEngine)
}


class MacroEngine {
    static let sharedInstance: MacroEngine = MacroEngine()
    
    let context: JSContext = JSContext()
    
    
    init() {
        setupExceptionHandler()
    }
    
    
    func addObject(object: MacroEngineSupport) {
        object.addMacroSupport(self)
    }


    func insertBlockAsObject<BlockType>(block: BlockType, key: String) {
        context.setObject(unsafeBitCast(block, AnyObject.self), forKeyedSubscript: key)
    }


    func setMethod(javascript: String, key: String) -> JSValue! {
        context.evaluateScript(javascript)

        return context.objectForKeyedSubscript(key)
    }


    private func setupExceptionHandler() {
        context.exceptionHandler = { context, error in
            print("JS Exception: \(error)")
        }
    }
}




class MacroMethod {

    private let engine = MacroEngine.sharedInstance
    private let jsValue: JSValue!

    var javascript: String
    let key: String


    init(javascript: String, key: String) {
        self.key = key
        self.javascript = javascript

        jsValue = engine.setMethod(javascript, key: key)
    }


    func call(params: [AnyObject]!) -> JSValue! {
        return jsValue.callWithArguments(params)
    }
}