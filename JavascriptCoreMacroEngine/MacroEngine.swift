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
    
    private func setupExceptionHandler() {
        context.exceptionHandler = { context, error in
            print("JS Exception: \(error)")
        }
    }
}