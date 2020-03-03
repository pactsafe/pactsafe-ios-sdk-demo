//
//  LoginWithCheckboxViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/11/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit
import FirebaseAuth

class LoginWithCheckboxViewController: UIViewController {
    
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!

    /// The PactSafe shared instance.
    private let ps = PSApp.shared
    
    /// The PactSafe group key that's used for login acceptance validation.
    private let psGroupKey: String = "example-mobile-app-group"
    
    /// Hold a reference of the signer ID to be used later.
    private var psSignerId: String?
    
    /// Hold a reference of the password text to be used later.
    private var passwordText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func checkStatus(signerId: String, password: String) {
        
        ps.signedStatus(for: signerId, groupKey: psGroupKey) { (needsAcceptance, contractIds) in
            if needsAcceptance {
                let psAcceptanceVc = PSAcceptanceViewController(self.psGroupKey, signerId: signerId, contractIds: contractIds, customData: nil)
                
                DispatchQueue.main.async {
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
        guard let signerId = self.psSignerId, let password = self.passwordText else { return }
        
        Auth.auth().signIn(withEmail: signerId, password: password) { (result, error) in
            // Authentication succeeded
            DispatchQueue.main.async {
                if error == nil {
                    self.segueToHome()
                } else {
                    let alert = self.basicAlert("Error", message: error?.localizedDescription ?? "Something went wrong logging in. Try Again.")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func submit(_ sender: UIButton) {
        // Make sure we're able to access the text properties within the text fields.
        guard let emailAddressText = emailAddress.text, let passwordText = password.text else { return }
        
        // Simple form validation to ensure fields contain something.
        if emailAddressText == "" {
            let alert = basicAlert("Error", message: "Missing Email Address. Please try again.")
            present(alert, animated: true, completion: nil)
        }
        if passwordText == "" {
            let alert = basicAlert("Error", message: "Missing Password. Please try again.")
            present(alert, animated: true, completion: nil)
        }
        
        self.psSignerId = emailAddressText
        self.passwordText = passwordText
        
        self.checkStatus(signerId: emailAddressText, password: passwordText)
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
