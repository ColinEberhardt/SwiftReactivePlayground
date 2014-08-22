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
    
    let textSignal: RACSignal = usernameTextField.rac_textSignal()

    let textLength = textSignal.mapAs {
      (text: NSString) -> NSNumber in
      return text.length
    }
    
    let filteredText = textLength.filterAs {
      (number: NSNumber) -> Bool in
      return number > 3
    }
    
    filteredText.subscribeNextAs {
      (length: NSNumber) in
      println(length)
    }
  }
  
  // MARK: implementation

  private func isValidUsername(username: String) -> Bool {
    return countElements(username) > 3
  }

  private func isValidPassword(password: String) -> Bool {
    return countElements(password) > 3
  }
}

