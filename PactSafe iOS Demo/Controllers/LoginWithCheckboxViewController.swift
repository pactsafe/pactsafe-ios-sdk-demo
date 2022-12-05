//
//  LoginWithCheckboxViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/11/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit

class LoginWithCheckboxViewController: UIViewController {
  @IBOutlet var emailAddress: UITextField!
  @IBOutlet var password: UITextField!

  /// The shared instance.
  private let ps = PSApp.shared

  /// The Ironclad Embedded Clickwrap group key that's used for login acceptance validation.
  private let psGroupKey: String = "example-mobile-app-group"

  /// Hold a reference of the signer ID to be used later.
  private var psSignerId: String?

  /// Hold a reference of the password text to be used later.
  private var passwordText: String?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func checkStatus(signerId: String, password: String) {
    ps.signedStatus(for: signerId, groupKey: psGroupKey) { needsAcceptance, contractIds in
      if needsAcceptance {
        DispatchQueue.main.async {
          let psAcceptanceVc = PSAcceptanceViewController(self.psGroupKey, signerId: signerId, contractIds: contractIds, customData: nil)
          psAcceptanceVc.delegate = self
          self.show(psAcceptanceVc, sender: nil)
        }
      } else {
        DispatchQueue.main.async {
          self.segueToHome()
        }
      }
    }
  }

  private func segueToHome() {
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: "secondLoginToHomeSegue", sender: self)
    }
  }

  private func loginUser() {
    self.segueToHome()
  }

  @IBAction func submit(_ sender: UIButton) {
    // Make sure we're able to access the text properties within the text fields.
    guard let emailAddressText = emailAddress.text, let passwordText = password.text else { return }

    // Simple form validation to ensure fields contain text.
    if emailAddressText.isEmpty {
      let alert = basicAlert("Error", message: "Missing Email Address. Please try again.")
      present(alert, animated: true, completion: nil)
    }
    if passwordText.isEmpty {
      let alert = basicAlert("Error", message: "Missing Password. Please try again.")
      present(alert, animated: true, completion: nil)
    }

    psSignerId = emailAddressText
    self.passwordText = passwordText

    checkStatus(signerId: emailAddressText, password: passwordText)
  }
}

extension LoginWithCheckboxViewController: PSAcceptanceViewControllerDelegate {
  func receivedAcceptance() {
    loginUser()
  }
}

extension LoginWithCheckboxViewController {
  func basicAlert(_ title: String, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(action)
    return alertController
  }
}
