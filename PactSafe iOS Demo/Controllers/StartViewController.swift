//
//  StartViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 10/9/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import UIKit
import FirebaseAuth
import PactSafe

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startToHomeSegue", sender: self)
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startToRegisterSegue", sender: self)
    }
    
    @IBAction func signUpProgrammaticButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startToRegisterProgrammaticSegue", sender: self)
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startToLoginSegue", sender: self)
    }
    
    @IBAction func loginWithCheckboxButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startToLoginCheckboxSegue", sender: self)
    }

}
