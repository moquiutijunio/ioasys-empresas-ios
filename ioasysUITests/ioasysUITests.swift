//
//  ioasysUITests.swift
//  ioasysUITests
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import XCTest
@testable import ioasys

class ioasysUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func test_error_login() {
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let emailTextField =  app.otherElements.textFields["E-mail"]
        emailTextField.tap()
        emailTextField.typeText("teste@teste.com")
        
        let passwordTextField =  app.otherElements.secureTextFields["Senha"]
        passwordTextField.tap()
        passwordTextField.typeText("12345")

        let toolbarButton = app.toolbars["Toolbar"].buttons["Ok"]
        toolbarButton.tap()
        
        let entryButton = elementsQuery.buttons["ENTRAR"]
        entryButton.tap()
        
        let cancelButton = app.alerts["Ops..."].scrollViews.otherElements.buttons["Cancelar"]
        cancelButton.tap()
    }
    
    func test_success_login() {
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let emailTextField =  app.otherElements.textFields["E-mail"]
        emailTextField.tap()
        emailTextField.typeText("testeapple@ioasys.com.br")
        
        let passwordTextField =  app.otherElements.secureTextFields["Senha"]
        passwordTextField.tap()
        passwordTextField.typeText("12341234")

        let toolbarButton = app.toolbars["Toolbar"].buttons["Ok"]
        toolbarButton.tap()
        
        let entryButton = elementsQuery.buttons["ENTRAR"]
        entryButton.tap()
        
        let searchButton = app.navigationBars["ioasys.HomeView"].buttons["ic search"]
        searchButton.tap()
    }
}
