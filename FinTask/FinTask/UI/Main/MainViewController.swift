//
//  MainViewController.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 05/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var users = [User]()
    
    
    
    // MARK: - Subviews
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainViewUserCell.self, forCellReuseIdentifier: MainViewUserCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.indicatorStyle = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 52.0
        return tableView
    }()
    
    lazy var statusBarBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        setupConstraints()
        
        view.backgroundColor = .defaultBackground
        
        reloadUsers()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Fixes content of the table view being shown under the status bar
        if #available(iOS 11.0, *) {} else {
            tableView.contentInset.top = topLayoutGuide.length
            tableView.scrollIndicatorInsets.top = topLayoutGuide.length
        }
    }
    
    
    
    // MARK: - Setup
    
    private func setupViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(statusBarBlurView)
    }
    
    private func setupConstraints() {
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: tableView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: statusBarBlurView, attribute: .top, multiplier: 1.0, constant: 0.0),
            topLayoutGuide.bottomAnchor.constraint(equalTo: statusBarBlurView.bottomAnchor),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: statusBarBlurView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: statusBarBlurView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    
    
    // MARK: - Fetching data
    
    func reloadUsers() {
        users.removeAll()
        tableView.reloadData()
        
        User.fetchAll(newUsersHandler: { [weak self] newUsers in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                let previousCount = strongSelf.users.count
                strongSelf.users.append(contentsOf: newUsers)
                var rows = [IndexPath]()
                for i in newUsers.indices {
                    rows.append(IndexPath(row: i + previousCount, section: 0))
                }
                strongSelf.tableView.insertRows(at: rows, with: .automatic)
            }
        }, errorHandler: { [weak self] error in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: "Could not fetch users", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    
    // MARK: - Actions
    
    func userSelected(_ user: User) {
        let detailVC = DetailViewController(with: user)
        present(detailVC, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
        let user = users[indexPath.row]
        userSelected(user)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewUserCell.reuseIdentifier, for: indexPath) as! MainViewUserCell
        cell.setup(with: users[indexPath.row])
        return cell
    }
}
