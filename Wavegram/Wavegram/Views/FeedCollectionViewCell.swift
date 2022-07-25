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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            profileImage, userName
        ].forEach { addSubview($0) }
    }
    
    // Basic Setting
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Configure
    public func configure(with model: Feed) {
        self.feeds = model
        profileImage.image = UIImage(named: model.owner.profileImage)
        userName.text = model.owner.name
        
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
        
        let userNameConstraints = [
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
            userName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ]
        
        [
            profileImageConstraints,
            userNameConstraints,
        ].forEach { NSLayoutConstraint.activate($0) }
        
    }
    
}
