//
//  userViewFeedCollectionViewCell.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/19.
//

import UIKit

final class UserViewFeedCollectionViewCell: UICollectionViewCell {
    
    private let feedImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        contentView.addSubview(feedImageView)
        applyConstraints()
    }
    
    func configure(with feed: Feed) {
        feedImageView.image = UIImage(named: feed.imageName!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserViewFeedCollectionViewCell {
    
    private func applyConstraints() {
        
        let feedImageViewConstraints = [
            feedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedImageView.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            feedImageView.widthAnchor.constraint(equalToConstant: contentView.frame.size.width)
        ]
        
        NSLayoutConstraint.activate(feedImageViewConstraints)
    }
}
