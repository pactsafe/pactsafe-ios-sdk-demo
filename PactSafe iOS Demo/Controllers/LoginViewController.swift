//
//  LoginViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/9/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import UIKit
import PactSafe
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let ps = PSApp.shared
    private var psSignerId: String?
    private let groupKey: String = "example-mobile-app-group"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    // Check acceptance status after user logs in
//    func checkLastContracts(_ signerId: String,
//                            completion: @escaping(_ needsAcceptance: Bool, _ contractIds: [Int]) -> Void) {
//
//        ps.getLatestSigned(forSignerId: signerId, inGroupKey: "example-mobile-app-group", nil) { (result) in
//            // TODO: Error handling
//            guard let result = result else { return }
//            var contractHasMajorUpdate: Bool = false
//            var contractIdsThatNeedUpdate: [Int] = []
//            for (key, value) in result {
//                if !value {
//                    contractHasMajorUpdate = true
//                    if let keyAsInt = Int(key) {
//                        contractIdsThatNeedUpdate.append(keyAsInt)
//                    }
//                }
//            }
//            completion(contractHasMajorUpdate, contractIdsThatNeedUpdate)
//        }
//    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        guard let emailAddressText = emailAddress.text else { return }
        guard let passwordText = password.text else { return }
        
        if emailAddressText == "" {
            let alert = basicAlert("Error", message: "Missing Email Address. Please try again.")
            self.present(alert, animated: true, completion: nil)
        } else if passwordText == "" {
            let alert = basicAlert("Error", message: "Missing Password. Please try again.")
            self.present(alert, animated: true, completion: nil)
        }
        
        ps.getSignedStatus(for: emailAddressText, in: groupKey) { (needsAcceptance, contractIds) in
            if needsAcceptance {
                guard let contractIds = contractIds else { return }
                self.ps.getContractsDetails(withContractIds: contractIds) { (contracts, error) in
                    var updatedContractMessage = "We've updated the following: "
                    for contract in contracts {
                        guard let contract = contract else { return }
                        let contractTitle = contract.publishedVersion.title
                        updatedContractMessage.append(contractTitle + " ")
                    }
                    updatedContractMessage.append("\n \n Please agree to these changes.")
                    DispatchQueue.main.async {
                        let alert = self.updatedTermsAlert("Updated Terms", message: updatedContractMessage, email: emailAddressText, password: passwordText)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.segueToHome()
                }
            }
        }
        
//        // Check to see if contracts have received major revisions and determine if they need acceptance
//        self.checkLastContracts(emailAddressText) { (needsUpdate, contractIds) in
//
//            if needsUpdate {
//                self.ps.getContractsDetails(withContractIds: contractIds) { (contracts, error) in
//                    var updatedContractMessage = "We've updated the following: "
//                    for contract in contracts {
//                        guard let contract = contract else { return }
//                        let contractTitle = contract.publishedVersion.title
//                        updatedContractMessage.append(contractTitle + " ")
//                    }
//                    updatedContractMessage.append("\n \n Please agree to these changes.")
//                    DispatchQueue.main.async {
//                        let alert = self.updatedTermsAlert("Updated Terms", message: updatedContractMessage, email: emailAddressText, password: passwordText)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            } else {
//                self.segueToHome()
//            }
//        }
    }
    
    func updatedTermsAlert(_ title: String, message: String, email: String, password: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Agreed", style: .default) { (alertAction) in
            self.loginUser(email, password)
        }
        
        let noAction = UIAlertAction(title: " Disagree", style: .destructive) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let notNowAction = UIAlertAction(title: "Not Now", style: .default) { (alertAction) in
            self.loginUser(email, password)
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(noAction)
        alertController.addAction(notNowAction)
        return alertController
    }
    
    func segueToHome() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
        }
    }
    
    func loginUser(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            // Authentication succeeded
            if error == nil {
                self.segueToHome()
            } else {
                let alert = self.errorAlert("Error", message: error?.localizedDescription ?? "Something went wrong logging in. Try Again.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController {
    func basicAlert(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }
    
    func errorAlert(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }
}
