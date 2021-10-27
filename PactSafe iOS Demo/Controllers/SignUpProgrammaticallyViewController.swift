//
//  SignUpProgrammaticallyViewController.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse on 2/4/20.
//  Copyright © 2020 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit

class SignUpProgrammaticallyViewController: UIViewController {
  @IBOutlet var formView: UIView!
  @IBOutlet var submitButton: PSSubmitButton!
  @IBOutlet var submitButtonTop: NSLayoutConstraint!

  private var clickWrap: PSClickWrapView?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureClickwrap()
  }

  private func configureClickwrap() {
    clickWrap = PSClickWrapView(frame: CGRect.zero)
    guard let clickWrap = clickWrap else { return }
    submitButtonTop.isActive = false
    clickWrap.loadContracts(withGroupKey: "example-mobile-app-group")
    clickWrap.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(clickWrap, belowSubview: formView)

    clickWrap.sizeToFit()

    NSLayoutConstraint.activate([
      clickWrap.topAnchor.constraint(equalTo: formView.bottomAnchor, constant: 16.0),
      clickWrap.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
      clickWrap.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
      clickWrap.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16.0),
    ])
  }
}
