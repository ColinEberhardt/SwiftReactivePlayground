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
    
    let validUsernameSignal = usernameTextField.rac_textSignal()
      .mapAs { (text: NSString) -> NSNumber in
        return self.isValidUsername(text)
      }
    
    validUsernameSignal.mapAs {
      (valid: NSNumber) -> UIColor in
      return valid.boolValue ? UIColor.clearColor() : UIColor.yellowColor()
    }.setKeyPath("backgroundColor", onObject: usernameTextField)
  }

  // MARK: implementation

  private func isValidUsername(username: String) -> Bool {
    return countElements(username) > 3
  }

  private func isValidPassword(password: String) -> Bool {
    return countElements(password) > 3
  }
}

