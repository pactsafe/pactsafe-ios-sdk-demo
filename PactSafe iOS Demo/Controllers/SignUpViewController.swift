//
//  SignUpViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 9/26/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import UIKit
import SafariServices
import FirebaseAuth
import PactSafe

class SignUpViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenterPassword: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pactSafeClickWrap: PSClickWrap!
    
    // MARK: - Properties
    private let ps = PSApp.shared

    // MARK: -  Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure your PactSafe Clickwrap
        configurePSClickwrap()
        
        // Configure default button state (default is false)
        configureSubmitButtonState()
    }
    
    func configurePSClickwrap() {
        // Optionally use a UITextView Delegate to open linked contracts in SFSafariViewController
        pactSafeClickWrap.textView.delegate = self
        
        // Set up and load contracts into clickwrap
        pactSafeClickWrap.loadContracts(withGroupKey: "example-mobile-app-group")
        
        // Only enable the submit button if checkbox is checked
        pactSafeClickWrap.checkbox.valueChanged = { (isChecked) in
            // If isChecked is true, enable submit button
            self.configureSubmitButtonState(isChecked)
        }
    }
    
    func configureSubmitButtonState(_ state: Bool = false) {
        // Disable submit button by default so we can ensure checkbox is selected
        submitButton.isEnabled = state
    }
    
    @IBAction func submitForm(_ sender: UIButton) {
        // Check to make sure we can access text in input fields
        guard let emailAddressText = emailAdress.text else { return }
        guard let firstNameText = firstName.text else { return }
        guard let lastNameText = lastName.text else { return }
        guard let passwordText = password.text else { return }
        guard let reenterPasswordText = reenterPassword.text else { return }
        
        // Basic validation to ensure fields aren't empty
        if emailAddressText == "" {
            formAlert("Email Address is missing.")
            return
        } else if firstNameText == "" {
            formAlert("First Name is missing.")
            return
        } else if lastNameText == "" {
            formAlert("Last Name is missing.")
            return
        } else if passwordText == "" {
            formAlert("Password is missing.")
            return
        }
        
        // Make sure passwords match each other
        if passwordText != reenterPasswordText {
            formAlert("Passwords do not match. Try again.")
            return
        }
        
        // Attempt to create a user with Firebase Auth
        Auth.auth().createUser(withEmail: emailAddressText, password: passwordText) { (result, error) in
            if error == nil {
                // Use PSCustomData to send additional data about the activty
                var customData = PSCustomData()
                customData.first_name = firstNameText
                customData.last_name = lastNameText
               
                self.sendToPactSafe(signerId: emailAddressText, customData: customData)
            } else {
                DispatchQueue.main.async {
                     self.formAlert(error?.localizedDescription ?? "We hit a snag :(. Please try again.")
                }
            }
        }
    }
    
    func sendToPactSafe(signerId: String, customData: PSCustomData?) {
        // PSClickWrap contains sendAgreed method to easily send acceptance
        // If additional functionality is needed, utilize the sendActivity method in PSApp
        self.pactSafeClickWrap.sendAgreed(signerId: signerId, customData: customData) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signUpToHomeSegue", sender: self)
                }
            } else {
                DispatchQueue.main.async {
                    self.formAlert("\(String(describing: error))")
                }
            }
        }
    }
}


// MARK: - Make link clicks open in SFSafariViewController
extension SignUpViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVc = SFSafariViewController(url: URL)
        present(safariVc, animated: true, completion: nil)
        return false
    }
}

// MARK: - Alert Handling
extension SignUpViewController {
    private func formAlert(_ errorMessage: String) {
        let alert = basicAlert("Error", message: errorMessage)
        present(alert, animated: true)
    }
    
    func basicAlert(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}
