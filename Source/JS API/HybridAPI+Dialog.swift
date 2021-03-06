//
//  HybridAPI+Dialog.swift
//  THGHybridWeb
//
//  Created by Angelo Di Paolo on 5/4/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol DialogJSExport: JSExport {
    func dialog(options: [String: AnyObject], _ callback: JSValue)
}

extension HybridAPI: DialogJSExport {
    
    func dialog(options: [String: AnyObject], _ callback: JSValue) {
        dialog.show(options, callback: callback)
    }
}
