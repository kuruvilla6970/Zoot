//
//  Navigation.swift
//  THGHybridWeb
//
//  Created by Angelo Di Paolo on 4/22/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import JavaScriptCore

@objc protocol NavigationJSExport: JSExport {
    func animateForward(options: [String: AnyObject]?,  _ callback: JSValue)
    func animateBackward()
    func popToRoot()
}

@objc public class Navigation: ViewControllerChild, NavigationJSExport {
    
    weak var webViewController: WebViewController? {
        return parentViewController as? WebViewController
    }
    
    func animateForward(options: [String: AnyObject]?, _ callback: JSValue) {
        let hideBottomBar = options?["tabBarHidden"]?.boolValue ?? false
        
        dispatch_async(dispatch_get_main_queue()) {
            self.webViewController?.pushWebViewController(hideBottomBar: hideBottomBar, callback: callback)
        }
    }
    
    func animateBackward() {
        dispatch_async(dispatch_get_main_queue()) {
            self.webViewController?.popWebViewController()
        }
    }
    
    func popToRoot() {
        dispatch_async(dispatch_get_main_queue()) {
            self.parentViewController?.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
}
