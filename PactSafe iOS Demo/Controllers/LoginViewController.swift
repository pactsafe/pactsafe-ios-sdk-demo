//
//  LoginViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/9/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit

class LoginViewController: UIViewController {
  @IBOutlet var emailAddress: UITextField!
  @IBOutlet var password: UITextField!

  /// The shared instance.
  private let ps = PSApp.shared

  /// The Ironclad Embedded Clickwrap group key used for checking acceptance status.
  private let groupKey: String = "example-mobile-app-group"

  /// Hold a reference of the signer ID for later usage.
  private var psSignerId: PSSigner?
  private var psGroupData: PSGroup?

  private var contractIds: [String]?
  private var contractVersions: [String]?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func sendAcceptance(for signerId: String) {
    var customData = PSCustomData()
    customData.companyName = "My Company"
    let signer = PSSigner(signerId: signerId, customData: customData)

    guard let groupData = psGroupData else { return }

    ps.sendActivity(.agreed, signer: signer, group: groupData) { error in
      if error != nil {
        print("Error sending acceptance")
      }
    }
  }

  private func updatedTermsAlert(_ title: String, message: String, email: String, password: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let acceptAction = UIAlertAction(title: "Agreed", style: .default) { _ in
      self.sendAcceptance(for: email)
      self.loginUser(email, password)
    }

    let noAction = UIAlertAction(title: "Disagree", style: .destructive) { _ in
      self.dismiss(animated: true, completion: nil)
    }

    let notNowAction = UIAlertAction(title: "Not Now", style: .default) { _ in
      self.loginUser(email, password)
    }

    alertController.addAction(acceptAction)
    alertController.addAction(noAction)
    alertController.addAction(notNowAction)
    return alertController
  }

  private func segueToHome() {
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
    }
  }

  private func loginUser(_ email: String, _ password: String) {
    self.segueToHome()
  }

  @IBAction func submit(_ sender: UIButton) {
    guard let signerId = emailAddress.text, let passwordText = password.text else { return }

    if signerId.isEmpty {
      let alert = basicAlert("Error", message: "Missing Email Address. Please try again.")
      present(alert, animated: true, completion: nil)
    }

    if passwordText.isEmpty {
      let alert = basicAlert("Error", message: "Missing Password. Please try again.")
      present(alert, animated: true, completion: nil)
    }

    /// Check the status of the specified signer ID within a PactSafe group.
    ps.signedStatus(for: signerId, groupKey: groupKey) { needsAcceptance, contractIds in
      if needsAcceptance {
        self.showContractUpdates(forSignerId: signerId,
                                 password: passwordText,
                                 filterContractIds: contractIds)
      } else {
        DispatchQueue.main.async {
          self.segueToHome()
        }
      }
    }
  }

  private func showContractUpdates(forSignerId signerId: String,
                                   password passwordText: String,
                                   filterContractIds: [String]? = nil) {
    ps.loadGroup(groupKey: groupKey) { groupData, _ in
      guard let groupData = groupData, let contractsData = groupData.contractData else { return }
      self.psGroupData = groupData

      var titlesOfContracts = [String]()

      var updatedContractsMessage: String = "We've updated the following: "

      if let cidsFilter = filterContractIds {
        contractsData.forEach { key, value in
          if cidsFilter.contains(key) { titlesOfContracts.append(value.title) }
        }
      } else {
        contractsData.forEach { _, value in
          titlesOfContracts.append(value.title)
        }
      }

      let contractTitles = titlesOfContracts.map { String($0) }.joined(separator: " and ")
      updatedContractsMessage.append(contractTitles)
      updatedContractsMessage.append(".\n \n Please agree to these changes.")

      DispatchQueue.main.async {
        let alert = self.updatedTermsAlert("Updated Terms", message: updatedContractsMessage, email: signerId, password: passwordText)
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}

/// Validation and alerts.
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
