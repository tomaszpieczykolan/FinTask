//
//  MainViewUserCell.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 09/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import UIKit
import SDWebImage

final class MainViewUserCell: UITableViewCell {
    
    static let reuseIdentifier = "FinTask-MainView-ReuseID-UserCell"
    
    
    
    // MARK: - Subviews
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .defaultText
        return label
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.textColor = .defaultSecondaryText
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            sourceLabel
        ])
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
            avatarImageView,
            verticalStackView
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        
        return stackView
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewHierarchy()
        setupConstraints()
        
        backgroundColor = .defaultBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    
    private func setupViewHierarchy() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        contentView.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: -4.0),
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 4.0),
            NSLayoutConstraint(item: contentView, attribute: .leadingMargin, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .trailingMargin, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        ])
        
        avatarImageView.addConstraints([
            NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
            NSLayoutConstraint(item: avatarImageView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        ])
        
        avatarImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    func setup(with model: User) {
        avatarImageView.sd_setImage(with: model.avatarURL)
        nameLabel.text = model.name
        sourceLabel.text = model.source
    }
}
