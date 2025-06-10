//
//  DummyViewController.swift
//  Bankey
//
//  Created by Wannipa Reya on 10/6/2568 BE.
//

import UIKit

class DummyViewController: UIViewController {

    let stackView = UIStackView()
    let label = UILabel()
    let logoutButton = UIButton(type: .system)

    weak var logoutDelegate: LoginViewController.LogoutDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension DummyViewController {

    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"

        //Logout Button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.configuration = .filled()
        logoutButton.setTitle("Logout", for: [])
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .primaryActionTriggered)
    }

    func layout() {

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutButton)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //logout
            logoutButton.topAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1)
        ])

    }

    @objc func logoutButtonTapped(sender: UIButton) {
        logoutDelegate?.didLogout()
    }
}
