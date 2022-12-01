//
//  SignUpViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 9/26/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import SafariServices
import UIKit

class SignUpViewController: UIViewController {
  // MARK: IBOutlets

  @IBOutlet var firstName: UITextField!
  @IBOutlet var lastName: UITextField!
  @IBOutlet var emailAdress: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var reenterPassword: UITextField!
  @IBOutlet var submitButton: PSSubmitButton!
  @IBOutlet var pactSafeClickWrap: PSClickWrapView!

  // MARK: - Properties

  /// The shared instance.
  private let ps = PSApp.shared

  // MARK: -  Methods

  override func viewDidLoad() {
    super.viewDidLoad()

    // Optionally use a UITextView Delegate to open linked contracts in SFSafariViewController
    pactSafeClickWrap.textView.delegate = self

    // Set up and load contracts into clickwrap
    pactSafeClickWrap.loadContracts(withGroupKey: "example-mobile-app-group")

    // Only enable the submit button if checkbox is checked
    pactSafeClickWrap.checkbox.valueChanged = { isChecked in
      // If isChecked is true, enable submit button
      self.configureSubmitButtonState(isChecked)
    }

    submitButton.setBackgroundColor(UIColor.lightGray, for: .disabled)

    // Configure the default button state (default is false)
    configureSubmitButtonState()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func configureSubmitButtonState(_ state: Bool = false) {
    DispatchQueue.main.async {
      // Disable submit button by default so we can ensure checkbox is selected
      self.submitButton.isEnabled = state
    }
  }

  @IBAction func submitForm(_ sender: UIButton) {
    // Check to make sure we can access text in input fields
    guard let emailAddressText = emailAdress.text,
          let firstNameText = firstName.text,
          let lastNameText = lastName.text,
          let passwordText = password.text,
          let reenterPasswordText = reenterPassword.text else { return }

    // Basic validation to ensure fields aren't empty.
    if emailAddressText.isEmpty {
      formAlert("Email Address is missing.")
      return
    } else if firstNameText.isEmpty {
      formAlert("First Name is missing.")
      return
    } else if lastNameText.isEmpty {
      formAlert("Last Name is missing.")
      return
    } else if passwordText.isEmpty {
      formAlert("Password is missing.")
      return
    }

    // Make sure passwords match each other
    if passwordText != reenterPasswordText {
      formAlert("Passwords do not match. Try again.")
      return
    }

    // Use PSCustomData to send additional data about the activity
    var customData = PSCustomData()
    customData.firstName = firstNameText
    customData.lastName = lastNameText

    // Create the signer with the specified id and custom data.
    let signer = PSSigner(signerId: emailAddressText, customData: customData)

    // Use the sendAgreed method on the clickwrap to send acceptance.
    self.pactSafeClickWrap.sendAgreed(signer: signer) { error in
      DispatchQueue.main.async {
        if error == nil {
          self.performSegue(withIdentifier: "signUpToHomeSegue", sender: self)
        } else {
          self.formAlert("\(String(describing: error))")
        }
      }
    }
  }
}

// MARK: - Make link clicks open in SFSafariViewController

extension SignUpViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    DispatchQueue.main.async {
      let safariVc = SFSafariViewController(url: URL)
      self.present(safariVc, animated: true, completion: nil)
    }
    return false
  }
}

// MARK: - Alert Handling

extension SignUpViewController {
  private func formAlert(_ errorMessage: String) {
    DispatchQueue.main.async {
      let alert = self.basicAlert("Error", message: errorMessage)
      self.present(alert, animated: true)
    }
  }

  private func basicAlert(_ title: String, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(action)
    return alertController
  }
}
