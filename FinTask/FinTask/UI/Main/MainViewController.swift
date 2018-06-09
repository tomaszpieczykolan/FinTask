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
    
    
    
    // MARK: - Setup
    
    private func setupViewHierarchy() {
        view.addSubview(statusBarBlurView)
    }
    
    private func setupConstraints() {
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: statusBarBlurView, attribute: .top, multiplier: 1.0, constant: 0.0),
            topLayoutGuide.bottomAnchor.constraint(equalTo: statusBarBlurView.bottomAnchor),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: statusBarBlurView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: statusBarBlurView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    
    
    // MARK: - Fetching data
    
    func reloadUsers() {
        users.removeAll()
        
        User.fetchAll(newUsersHandler: { [weak self] newUsers in
            guard let strongSelf = self else { return }
            strongSelf.users.append(contentsOf: newUsers)
        }, errorHandler: { [weak self] error in
            let alertController = UIAlertController(title: "Error", message: "Could not fetch users", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alertController, animated: true, completion: nil)
        })
    }
}
