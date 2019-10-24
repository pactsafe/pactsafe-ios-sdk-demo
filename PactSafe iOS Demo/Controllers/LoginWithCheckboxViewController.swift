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

    // Initialize the PSApp.
    let ps = PSApp.shared
    
    // We'll want to have a place to store the psSignerId for use later.
    private var psSignerId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkStatus(signerId: String) {
        // Set Group Key
        let groupKey: String = "example-mobile-app-group"
        
        ps.getSignedStatus(for: signerId, in: groupKey) { (needsAcceptance, contractIds) in
            if needsAcceptance {
                DispatchQueue.main.async {
                    let psAcceptanceVc = PSAcceptanceViewController(groupKey, signerId, contractIds)
                    psAcceptanceVc.modalPresentationStyle = .automatic
                    psAcceptanceVc.modalTransitionStyle = .coverVertical
                    self.present(psAcceptanceVc, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.segueToHome()
                }
            }
        }
    }
    
    // Check to see if signer has accepted most recent major contract versions in a group
//    func checkLatestContracts(signerId: String) {
//
//        // Set group key
//        let groupkey: String = "example-mobile-app-group"
//
//        // Get latest signed contracts using signature id within a specific group
//        // Completion handler returns a dictionary of contract ids and if they have been accepted (boolean)
//        ps.getLatestSigned(forSignerId: signerId, inGroupKey: groupkey, nil) { (contractsResult) in
//
//            // Check to make sure we have data before moving forward
//            guard let contractsResult = contractsResult else { return }
//
//            // By default, we'll assume the contracts have been accepted
//            var acceptedStatus: Bool = true
//
//            // If contracts aren't accepted, hold their ids to be used later on
//            var contractsNotAccepted: [Int] = []
//
//            // Loop through the results to see if a contract(s) need to be updated
//            for (key, value) in contractsResult {
//
//                // If a contract has not been accepted (false), mark accepted status as false
//                if !value {
//                    acceptedStatus = false
//
//                    // Append the contract id as an Int to contractsNotAccepted
//                    if let contractIdAsInt = Int(key) {
//                        contractsNotAccepted.append(contractIdAsInt)
//                    }
//                }
//            }
//
//            // If a contract hasn't been accepted, show the PSAcceptanceViewController
//            if !acceptedStatus {
//                DispatchQueue.main.async {
//                    let psAcceptanceVC = PSAcceptanceViewController(groupkey, signerId, contractsNotAccepted)
//                    psAcceptanceVC.modalPresentationStyle = .automatic
//                    psAcceptanceVC.modalTransitionStyle = .coverVertical
//                    self.present(psAcceptanceVC, animated: true, completion: nil)
//                }
//            } else {
//                // If a user has accepted the most recent contracts, move them forward
//                DispatchQueue.main.async {
//                    self.segueToHome()
//                }
//            }
//
//        }
//    }

    @IBAction func submit(_ sender: UIButton) {
        // Make sure we're able to access the text properties within the text fields.
        guard let emailAddressText = emailAddress.text else { return }
        guard let passwordText = password.text else { return }

        // Simple form validation to ensure fields contain something.
        if emailAddressText == "" {
            let alert = basicAlert("Error", message: "Missing Email Address. Please try again.")
            present(alert, animated: true, completion: nil)
        } else if passwordText == "" {
            let alert = basicAlert("Error", message: "Missing Password. Please try again.")
            present(alert, animated: true, completion: nil)
        }
        
//        self.checkLatestContracts(signerId: emailAddressText)
        
        self.checkStatus(signerId: emailAddressText)

    }

    func segueToHome() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "secondLoginToHomeSegue", sender: self)
        }
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
