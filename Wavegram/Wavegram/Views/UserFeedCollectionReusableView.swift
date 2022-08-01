//
//  userViewFeedCollectionViewCell.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/19.
//

import UIKit

protocol UserFeedCollectionReusableViewDelegate: AnyObject {
    func segmentedControlDidTapSection(feeds : [Feed])
}

class UserFeedCollectionReusableView: UICollectionReusableView {

    static let identifier = "FeedCollectionReusableView"
    private let imageHeight: CGFloat = 100
    private let stackHeight: CGFloat = 41
    private let stackWidth: CGFloat = 50
    private let leadingPadding: CGFloat = 20
    private let trailingPadding: CGFloat = -20

    var delegate: UserFeedCollectionReusableViewDelegate?

    // fullCoverView
    private let fullCoverView: UIView = {

        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false

        return uiview
    }()

    // user Profile Image
    lazy var profileImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.image = UIImage(named: "woodyProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageHeight / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // Owned Feed Indicator
   private let ownedFeedStackView: UIStackView = {

       let stackView = UIStackView()
       stackView.axis = .vertical
       stackView.distribution = .fill
       stackView.translatesAutoresizingMaskIntoConstraints = false

       return stackView
   }()

   private let ownedFeedLabel: UILabel = {

       let label = UILabel()
       label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "게시물"

       return label
   }()

   private let numberOfOwnedFeedLabel: UILabel = {

       let label = UILabel()
       label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "11"
       label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

       return label
   }()

   // Contributed Feed Indicator
   private let contributedFeedStackView: UIStackView = {

       let stackView = UIStackView()
       stackView.axis = .vertical
       stackView.distribution = .fillProportionally
       stackView.translatesAutoresizingMaskIntoConstraints = false

       return stackView
   }()

   private let contributedFeedLabel: UILabel = {

       let label = UILabel()
       label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "기여"

       return label
   }()

   private let numberOfContributedFeedLabel: UILabel = {

       let label = UILabel()
       label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "14"
       label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

       return label
   }()

   // SegmentedControl
   private let segmentedControl: UISegmentedControl = {

       let segment = UISegmentedControl(items: ["내피드", "기여"])
       segment.selectedSegmentIndex = 0
       segment.backgroundColor = .black
       segment.tintColor = .gray
       segment.translatesAutoresizingMaskIntoConstraints = false
       segment.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)

       return segment
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

extension UserFeedCollectionReusableView {

    func configure(with user: User) {
        profileImageView.image = UIImage(named: user.profileImage)
    }

    @objc func segmentedValueChanged(_ sender:UISegmentedControl) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")

        if sender.selectedSegmentIndex == 0 {
            delegate?.segmentedControlDidTapSection(feeds: DataManager.shared.userOwnedFeeds)
        } else {
            delegate?.segmentedControlDidTapSection(feeds: DataManager.shared.userContributedFeeds)
        }
     }

    private func configureView() {
        [fullCoverView, segmentedControl]
            .forEach { item in
                addSubview(item)
            }

        [profileImageView, ownedFeedStackView, contributedFeedStackView]
            .forEach { item in
                fullCoverView.addSubview(item)
            }

        [numberOfOwnedFeedLabel, ownedFeedLabel]
            .forEach { item in
                ownedFeedStackView.addArrangedSubview(item)
            }

        [numberOfContributedFeedLabel, contributedFeedLabel]
            .forEach { item in
                contributedFeedStackView.addArrangedSubview(item)
            }
    }

    private func applyConstraints() {

        let fullCoverViewConstraints = [
            fullCoverView.topAnchor.constraint(equalTo: self.topAnchor, constant: 19),
            fullCoverView.heightAnchor.constraint(equalToConstant: imageHeight),
            fullCoverView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            fullCoverView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingPadding),
        ]

        let profileImageViewConstraints = [
            profileImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            profileImageView.leadingAnchor.constraint(equalTo: fullCoverView.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: fullCoverView.centerYAnchor),
        ]

        let contributedFeedStackViewConstraints = [
            contributedFeedStackView.heightAnchor.constraint(equalToConstant: stackHeight),
            contributedFeedStackView.widthAnchor.constraint(equalToConstant: stackWidth),
            contributedFeedStackView.trailingAnchor.constraint(equalTo: fullCoverView.trailingAnchor),
            contributedFeedStackView.centerYAnchor.constraint(equalTo: fullCoverView.centerYAnchor),
        ]

        let ownedFeedStackViewConstraints = [
            ownedFeedStackView.heightAnchor.constraint(equalToConstant: stackHeight),
            ownedFeedStackView.widthAnchor.constraint(equalToConstant: stackWidth),
            ownedFeedStackView.trailingAnchor.constraint(equalTo: contributedFeedStackView.leadingAnchor, constant: trailingPadding),
            ownedFeedStackView.centerYAnchor.constraint(equalTo: fullCoverView.centerYAnchor),
        ]

        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: fullCoverView.bottomAnchor, constant: 26),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]

        [
            fullCoverViewConstraints,
            profileImageViewConstraints,
            contributedFeedStackViewConstraints,
            ownedFeedStackViewConstraints,
            segmentedControlConstraints,
        ]
            .forEach { constraints in
                NSLayoutConstraint.activate(constraints)
        }
    }
}
