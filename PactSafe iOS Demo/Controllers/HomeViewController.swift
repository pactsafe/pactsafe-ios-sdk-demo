//
//  HomeViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/9/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Error signing out: \(error)")
        }
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
