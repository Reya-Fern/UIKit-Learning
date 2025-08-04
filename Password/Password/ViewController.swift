//
//  ViewController.swift
//  Password
//
//  Created by Wannipa Reya on 1/8/2568 BE.
//

import UIKit

class ViewController: UIViewController {

    let stackView = UIStackView()
    let newPasswordTextField = PasswordTextField(placeHolderText: "New Password")
    let criteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ViewController {

    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

        criteriaView.translatesAutoresizingMaskIntoConstraints = false

    }

    func layout() {
//        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(criteriaView)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
//            newPasswordTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
//            view.trailingAnchor.constraint(equalToSystemSpacingAfter: newPasswordTextField.trailingAnchor, multiplier: 1),
//            newPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
