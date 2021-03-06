//
//  NavigationBarTests.swift
//  THGHybridWeb
//
//  Created by Angelo Di Paolo on 7/8/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import UIKit
import XCTest
import THGHybridWeb

class NavigationBarTests: XCTestCase {
    
    let setTitleCallbackName = "setTitleCallback"
    let removeTitleCallbackName = "removeTitleCallback"
    let setButtonsCallbackName = "setButtonsCallback"
    let removeButtonsCallbackName = "removeButtonsCallback"

    let expectedTitle = "What is your name?"
    let expectedLeftButtonTitle = "Cancel"
    let expectedRightButtonTitle = "Done"
    
    var setButtonsScript: String {
        let buttons = "[{title:'\(expectedLeftButtonTitle)',id:'cancel'},{title:'\(expectedRightButtonTitle)',id:'done'}]"
        let callback = "function (id) {}"
        return "\(HybridAPI.exportName).navigationBar.setButtons(\(buttons), \(callback), \(setButtonsCallbackName))"
    }
    
    // MARK: Title Tests
    
    func testSetTitle() {
        let completedExpectation = expectationWithDescription("Set title complete")
        
        let webController = WebViewController()
        webController.addHybridAPI()
        
        let callback: @objc_block () -> Void = {
            self.validateSetTitleWithWebViewController(webController)
            completedExpectation.fulfill()
        }
        
        webController.bridge.context.setObject(unsafeBitCast(callback, AnyObject.self), forKeyedSubscript: setTitleCallbackName)


        let script = "\(HybridAPI.exportName).navigationBar.setTitle('\(expectedTitle)', \(setTitleCallbackName))"
        webController.bridge.context.evaluateScript(script)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func validateSetTitleWithWebViewController(webViewController: WebViewController) {
        XCTAssertNotNil(webViewController.navigationItem.title)
        XCTAssertEqual(webViewController.navigationItem.title!, expectedTitle)
    }
    
    func testRemoveTitle() {
        let setExpectation = expectationWithDescription("Set title complete")
        let removeExpectation = expectationWithDescription("Remove title complete")

        let webController = WebViewController()
        webController.addHybridAPI()
        
        // set title
        let callback: @objc_block () -> Void = {
            self.validateSetTitleWithWebViewController(webController)
            setExpectation.fulfill()
        }
        webController.bridge.context.setObject(unsafeBitCast(callback, AnyObject.self), forKeyedSubscript: setTitleCallbackName)
        
        let setButtonsScript = "\(HybridAPI.exportName).navigationBar.setTitle('\(expectedTitle)', \(setTitleCallbackName))"
        webController.bridge.context.evaluateScript(setButtonsScript)
        
        // remove title
        let removeCallback: @objc_block () -> Void = {
            XCTAssertNil(webController.navigationItem.title)
            removeExpectation.fulfill()
        }
        webController.bridge.context.setObject(unsafeBitCast(removeCallback, AnyObject.self), forKeyedSubscript: removeTitleCallbackName)

        let removeScript = "\(HybridAPI.exportName).navigationBar.setTitle(null, \(removeTitleCallbackName))"
        webController.bridge.context.evaluateScript(removeScript)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    // MARK: Buttons Tests
    
    func testSetButtons() {
        let completedExpectation = expectationWithDescription("Set buttons complete")
        
        let webViewController = WebViewController()
        webViewController.addHybridAPI()
        
        let callback: @objc_block () -> Void = {
            self.validateSetButtonsWithWebViewController(webViewController)
            completedExpectation.fulfill()
        }
        webViewController.bridge.context.setObject(unsafeBitCast(callback, AnyObject.self), forKeyedSubscript: setButtonsCallbackName)
        
        webViewController.bridge.context.evaluateScript(setButtonsScript)

        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func validateSetButtonsWithWebViewController(webViewController: WebViewController) {
        let leftButtonTitle = webViewController.navigationItem.leftBarButtonItem?.title!
        XCTAssertEqual(leftButtonTitle!, self.expectedLeftButtonTitle)
        let rightButtonTitle = webViewController.navigationItem.rightBarButtonItem?.title!
        XCTAssertEqual(rightButtonTitle!, self.expectedRightButtonTitle)
        
        XCTAssertNotNil(webViewController.navigationItem.leftBarButtonItem!)
        XCTAssertNotNil(webViewController.navigationItem.rightBarButtonItem!)
    }
    
    func testRemoveButtons(){
        let setExpectation = expectationWithDescription("Set buttons complete")
        let removeExpectation = expectationWithDescription("Remove buttons complete")
        
        let webViewController = WebViewController()
        webViewController.addHybridAPI()
        
        // set buttons
        let callback: @objc_block () -> Void = {
            self.validateSetButtonsWithWebViewController(webViewController)
            setExpectation.fulfill()
        }
        webViewController.bridge.context.setObject(unsafeBitCast(callback, AnyObject.self), forKeyedSubscript: setButtonsCallbackName)
        
        webViewController.bridge.context.evaluateScript(self.setButtonsScript)
        
        // remove buttons
        let removeCallback: @objc_block () -> Void = {
            XCTAssertNil(webViewController.navigationItem.leftBarButtonItem)
            XCTAssertNil(webViewController.navigationItem.rightBarButtonItem)
            removeExpectation.fulfill()
        }
        webViewController.bridge.context.setObject(unsafeBitCast(removeCallback, AnyObject.self), forKeyedSubscript: removeButtonsCallbackName)
        
        
        let removeScript = "\(HybridAPI.exportName).navigationBar.setButtons(null, null, \(removeButtonsCallbackName))"
        webViewController.bridge.context.evaluateScript(removeScript)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
