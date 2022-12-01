//
//  StartViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/9/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit

class StartViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  @IBAction func signUpButton(_ sender: UIButton) {
    performSegue(withIdentifier: "startToRegisterSegue", sender: self)
  }

  @IBAction func signUpProgrammaticButton(_ sender: UIButton) {
    performSegue(withIdentifier: "startToRegisterProgrammaticSegue", sender: self)
  }

  @IBAction func loginButton(_ sender: UIButton) {
    performSegue(withIdentifier: "startToLoginSegue", sender: self)
  }

  @IBAction func loginWithCheckboxButton(_ sender: UIButton) {
    performSegue(withIdentifier: "startToLoginCheckboxSegue", sender: self)
  }
}
