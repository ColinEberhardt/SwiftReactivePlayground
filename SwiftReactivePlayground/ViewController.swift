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
  
  let signInService: DummySignInService;
  
  // MARK: initialisation
  
  required init(coder aDecoder: NSCoder) {
    signInService = DummySignInService()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    func validToBackground(valid: NSNumber) -> UIColor {
      return valid.boolValue ? UIColor.clearColor() : UIColor.yellowColor()
    }
    
    func isValidText(validator:(String) -> Bool)(text: NSString) -> NSNumber {
      return validator(text)
    }
    
    let validUsernameSignal = usernameTextField.rac_textSignal()
      .mapAs(isValidText(isValidUsername))
      .distinctUntilChanged()
    
    let validPasswordSignal = passwordTextField.rac_textSignal()
      .mapAs(isValidText(isValidPassword))
      .distinctUntilChanged()
    
    RAC(usernameTextField, "backgroundColor") << validUsernameSignal.mapAs(validToBackground)
    
    RAC(passwordTextField, "backgroundColor") << validPasswordSignal.mapAs(validToBackground)
    
    let signUpActiveSignal = RACSignalEx.combineLatestAs([validUsernameSignal, validPasswordSignal]) {
      (validUsername: NSNumber, validPassword: NSNumber) -> NSNumber in
      return validUsername && validPassword
    }
    
    signUpActiveSignal.subscribeNextAs {
      (active: NSNumber) in
      self.signInButton.enabled = active
    }

    signInButton.rac_signalForControlEvents(.TouchUpInside)
      .flattenMap {
        (any) -> RACSignal in
        self.signInSignal()
      }.subscribeNextAs {
        (success: NSNumber) in
        self.handleSignInResult(success.boolValue)
      }
  }

  func handleSignInResult(success: Bool) {
    if success {
      self.performSegueWithIdentifier("signInSuccess", sender: self)
    } else {
      UIAlertView(title: "Sign in failure", message: "try harder next time ;-)",
        delegate: nil, cancelButtonTitle: "OK").show()
    }
  }

  // MARK: implementation

  func signInSignal() -> RACSignal {
    return RACSignal.createSignal {
      (subscriber) -> RACDisposable! in
      
      println("Sign-in initiated")
      self.signInService.signInWithUsername(self.usernameTextField.text,
                                  password: self.passwordTextField.text) {
        (success) in
        println("Sign-in completed")
        subscriber.sendNext(success)
        subscriber.sendCompleted()
      }
      return nil
    }
  }

  private func isValidUsername(username: String) -> Bool {
    return countElements(username) > 3
  }

  private func isValidPassword(password: String) -> Bool {
    return countElements(password) > 3
  }
}

