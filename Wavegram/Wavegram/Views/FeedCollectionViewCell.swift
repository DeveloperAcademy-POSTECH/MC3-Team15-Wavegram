//
//  FeedCollectionViewCell.swift
//  Wavegram
//
//  Created by eunji on 2022/07/25.
//

import UIKit
import AVFoundation

class FeedCollectionViewCell: UICollectionViewCell {
    
    var feeds: Feed?
    
    // Profile Image
    // TODO: UIIMageView -> UIButton
    private let profileImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // UserName
    private let userName: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        label.textAlignment = .left
        
        return label
    }()
    
    // originLabel
    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // originButton
    private let originButton: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToOriginFeed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func moveToOriginFeed() {
        // TODO: Move to the Original Feed / People
        print("Move to Original Feed / People")
    }
    
    // AdditionalButton
    private let additionalButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
                
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            profileImage, userName,
            originLabel, originButton,
            additionalButton
        ].forEach { addSubview($0) }
    }
    
    // Basic Setting
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Configure
    public func configure(with model: Feed) {
        self.feeds = model
        
        if model.isOriginal {
            profileImage.image = UIImage(named: model.owner.profileImage)
            userName.text = model.owner.name
        } else {
            guard let profileImageString = model.contributor?.profileImage else {return}
            profileImage.image = UIImage(named: profileImageString)
            userName.text = model.contributor?.name
        }
        
        
        // TODO: Need Model Understand
        if model.isOriginal {
            originLabel.text = ""
        } else {
            originLabel.text = "Begin by"
            originButton.setTitle(model.owner.name, for: .normal)
        }
        
        let buttonSymbolName = model.owner.name == "woody_." ? "ellipsis" : "rectangle.stack.badge.plus"
        additionalButton.setImage(UIImage(systemName: buttonSymbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        
        applyConstraints(model)
    }
    
    // Constraints
    private func applyConstraints(_ model: Feed) {
        let r = frame.width * 21.0 / 175.0 // ProfileImage 반지름
        
        let profileImageConstraints = [
            profileImage.topAnchor.constraint(equalTo: topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            // 42: 350 = 21:175
            profileImage.heightAnchor.constraint(equalToConstant: r),
            profileImage.widthAnchor.constraint(equalToConstant: r)
        ]
        
        var userNameConstraints = [
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
            userName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ]
        
        // TODO: Need Model Understand
        if model.isOriginal {
            userNameConstraints = [
                userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
                userName.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            ]
        }
        
        let originLabelConstraints = [
            originLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
            originLabel.topAnchor.constraint(equalTo: userName.bottomAnchor),
            originLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor)
        ]
        
        let originButtonConstraints = [
            originButton.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: 4),
            originButton.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor)
        ]
        
        let additionalButtonConstraints = [
            additionalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            additionalButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
        ]
        
        [
            profileImageConstraints,userNameConstraints,
            originLabelConstraints, originButtonConstraints,
            additionalButtonConstraints
        ].forEach { NSLayoutConstraint.activate($0) }
        
    }
    
}
