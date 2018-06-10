//
//  DetailViewController.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 10/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .defaultText
        return label
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .defaultSecondaryText
        return label
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
        
        if let model = user {
            setup(with: model)
        }
    }
    
    
    
    // MARK: - Setup
    
    private func setupViewHierarchy() {
        view.addSubview(toolbar)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(sourceLabel)
    }
    
    private func setupConstraints() {
        view.addConstraints([
            topLayoutGuide.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: toolbar, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: toolbar, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: toolbar, attribute: .bottom, relatedBy: .equal, toItem: avatarImageView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: avatarImageView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: avatarImageView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: avatarImageView, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .top, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: sourceLabel, attribute: .top, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: sourceLabel, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: sourceLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: sourceLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        ])
        
        let avatarARConstraint = NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: avatarImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        avatarARConstraint.priority = .defaultHigh
        avatarImageView.addConstraint(avatarARConstraint)
        
        toolbar.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        sourceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setup(with model: User) {
        avatarImageView.sd_setImage(with: model.avatarURL)
        nameLabel.text = model.name
        sourceLabel.text = model.source
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
