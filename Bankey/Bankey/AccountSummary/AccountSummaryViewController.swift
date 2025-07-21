//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Wannipa Reya on 17/6/2568 BE.
//

import UIKit

class AccountSummaryViewController: UIViewController {

    //Request Models
    var profile: Profile?
    var accounts: [Account] = []

    //View Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountsCellViewModels: [AccountSummaryCell.ViewModel] = []

    //Components
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshControl = UIRefreshControl()

    var isLoaded = false


    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
//        fetchAccounts()
        fetchData()
    }

    private func setupTableView() {
        
        tableView.backgroundColor = appColor
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableHeaderView() {

        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size

        tableView.tableHeaderView = headerView
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)

        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountsCellViewModels.isEmpty else {
            return UITableViewCell()
        }

        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            let account = accountsCellViewModels[indexPath.row]
            cell.configure(with: account)

            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

//extension AccountSummaryViewController {
//    private func fetchAccounts() {
//        let savings = AccountSummaryCell.ViewModel(accountType: .Banking,
//                                                   accountName: "Basic Savings",
//                                                   balance: 929466.23)
//        let chequing = AccountSummaryCell.ViewModel(accountType: .Banking,
//                                                    accountName: "No-Fee All-In Chequing",
//                                                    balance: 17562.44)
//        let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard,
//                                                accountName: "Visa Avion Card",
//                                                balance: 412.83)
//        let masterCard = AccountSummaryCell.ViewModel(accountType: .CreditCard,
//                                                      accountName: "Student Mastercard",
//                                                      balance: 50.83)
//        let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment,
//                                                       accountName: "Tax-Free Saver",
//                                                       balance: 2000.00)
//        let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment,
//                                                       accountName: "Growth Fund",
//                                                       balance: 15000.00)
//        
//        accountsCellViewModels.append(savings)
//        accountsCellViewModels.append(chequing)
//        accountsCellViewModels.append(visa)
//        accountsCellViewModels.append(masterCard)
//        accountsCellViewModels.append(investment1)
//        accountsCellViewModels.append(investment2)
//    }
//}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {

        let group = DispatchGroup()

        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))

        group.enter()
        fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error: error)
            }
            group.leave()
        }

        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.displayError(error: error)
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.tableView.refreshControl?.endRefreshing()

            guard let profile = self.profile else { return }

            self.isLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
        }
    }

    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }

    private func configureTableCells(with accounts: [Account]) {
        accountsCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }

    private func displayError(error: NetworkError) {
        let title: String
        let message: String

        switch error {
        case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request. Please try again."
        }
        self.showErrorAlert(title: title, message: message)
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }

    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }

    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
}
