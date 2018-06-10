//
//  DetailViewController.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 10/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    
    private var user: User?
    
    // MARK: - Subviews
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        toolbar.barStyle = .black
        let closeItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed))
        toolbar.items = [closeItem]
        return toolbar
    }()
    
    
    
    // MARK: - Lifecycle
    
    convenience init(with user: User) {
        self.init()
        
        self.user = user
    }
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        setupConstraints()
        
        view.backgroundColor = .defaultBackground
    }
    
    
    
    // MARK: - Setup
    
    private func setupViewHierarchy() {
        view.addSubview(toolbar)
    }
    
    private func setupConstraints() {
        view.addConstraints([
            topLayoutGuide.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: toolbar, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: toolbar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    
    
    // MARK: - Actions
    
    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
