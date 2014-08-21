//
//  ViewController.swift
//  SwiftReactivePlayground
//
//  Created by Colin Eberhardt on 20/08/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: outlets

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signInButton: UIButton!
  
  // MARK: properties
  
  var passwordIsValid: Bool = false;
  var usernameIsValid: Bool = false;
  let signInService: DummySignInService;
  
  // MARK: initialisation
  
  required init(coder aDecoder: NSCoder) {
    signInService = DummySignInService()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUIState()
    
    usernameTextField.addTarget(self, action: "usernameTextFieldChanged", forControlEvents: .EditingChanged)
    passwordTextField.addTarget(self, action: "passwordTextFieldChanged", forControlEvents: .EditingChanged)
  }
  
  // MARK: implementation

  @IBAction func signinButtonTouched(sender: UIButton) {
    signInButton.enabled = false
    
    signInService.signInWithUsername(usernameTextField.text, password: passwordTextField.text) {
      [unowned self] (success: Bool) in
      self.signInButton.enabled = true
      if success {
        self.performSegueWithIdentifier("signInSuccess", sender: self)
      } else {
        UIAlertView(title: "Sign in failure", message: "try harder next time ;-)",
          delegate: nil, cancelButtonTitle: "OK").show()
      }
    }
  }

  private func isValidUsername(username: String) -> Bool {
    return countElements(username) > 3
  }

  private func isValidPassword(password: String) -> Bool {
    return countElements(password) > 3
  }
  
  private func updateUIState() {
    func color(valid: Bool) -> UIColor {
      return valid ? UIColor.clearColor() : UIColor.yellowColor()
    }
    usernameTextField.backgroundColor = color(usernameIsValid)
    passwordTextField.backgroundColor = color(passwordIsValid)
    signInButton.enabled = usernameIsValid && passwordIsValid
  }
  
  func usernameTextFieldChanged() {
    usernameIsValid = isValidUsername(usernameTextField.text)
    updateUIState()
  }
  
  func passwordTextFieldChanged() {
    passwordIsValid = isValidUsername(passwordTextField.text)
    updateUIState()
  }
  
  
}

