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
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .defaultBackground
        
        reloadUsers()
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
