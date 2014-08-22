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
    
    let validPasswordSignal = passwordTextField.rac_textSignal()
      .mapAs(isValidText(isValidPassword))
    
    RAC(usernameTextField, "backgroundColor") << validUsernameSignal.mapAs(validToBackground)
    
    RAC(passwordTextField, "backgroundColor") << validPasswordSignal.mapAs(validToBackground)
  }

  // MARK: implementation

  private func isValidUsername(username: String) -> Bool {
    return countElements(username) > 3
  }

  private func isValidPassword(password: String) -> Bool {
    return countElements(password) > 3
  }
}

