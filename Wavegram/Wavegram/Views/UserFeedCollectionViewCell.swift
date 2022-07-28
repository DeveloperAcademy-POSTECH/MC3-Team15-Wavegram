//
//  UserFeedCollectionViewCell.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/28.
//

import UIKit

class UserFeedCollectionViewCell: UICollectionViewCell {

    private let imageView: UIImageView = {

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserFeedCollectionViewCell {

    func configure(with feed: Feed) {
        imageView.image = UIImage(named: feed.imageName ?? "")
    }

    private func configureView() {
        [imageView]
            .forEach { item in
                addSubview(item)
            }
    }

    private func applyConstraints() {

        let imageViewConstraints = [
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ]

        [imageViewConstraints]
            .forEach { item in
                NSLayoutConstraint.activate(item)
            }
    }
}
