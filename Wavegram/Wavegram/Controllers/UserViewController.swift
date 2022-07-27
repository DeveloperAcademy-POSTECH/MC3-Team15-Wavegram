//
//  UserViewController.swift
//  OsungTS-MC3
//
//  Created by Kim Insub on 2022/07/12.
//

import UIKit
import SwiftUI

final class UserViewController: UIViewController {
    
    private let user = User(name: "woody__.", profileImage: "woodyProfileImage")
    
    private var feeds = [Feed](repeating: Feed(id: 1001, owner: User(name: "woody__.", profileImage: "woodyProfileImage"), contributor: nil, title: "어쩌구", description: "저쩌구", imageName: "someImage", audioName: "someAudio"), count: 25)
    
    private let upperBarHeight: CGFloat = 100
    
    private let indicatorWidth: CGFloat = 45
    
    private let indicatorHeight: CGFloat = 41
    
    private let segmentedControlHeight: CGFloat = 32
    
    private let leadingPadding: CGFloat = 16
    
    private let trailingPadding: CGFloat = -16

    // Scroll View
    private let scrollView: UIScrollView = {

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    // Full Cover View
    private let fullCoverView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    // Upper Bar

    private let upperView: UIView = {

        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    // user Profile Image
    lazy var profileImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.image = UIImage(named: "woodyProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = upperBarHeight / 2
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

        return segment
    }()
    
    // CollectionView
    private let feedCollectionView: UICollectionView = {

        let surfaceLength = UIScreen.main.bounds.width / 3

        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: surfaceLength, height: surfaceLength)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserViewFeedCollectionViewCell.self, forCellWithReuseIdentifier: UserViewFeedCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()

    // viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self

        configureNavbar()
        configureView()
    }

    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedCollectionView.heightAnchor.constraint(equalToConstant: feedCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
    }
    
    // Configure Nav Bar
    private func configureNavbar() {

        // user name
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        leftButton.setTitle("\(user.name)", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        let leftButtonItem = UIBarButtonItem(customView: leftButton)

        // plus button
        let image = UIImage(systemName: "plus.square")
        let rightButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)


        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.tintColor = .white
    }
    
    // Configure View
    private func configureView() {

        view.addSubview(scrollView)
        scrollView.addSubview(fullCoverView)

        [upperView, segmentedControl, feedCollectionView]
            .forEach { item in
                fullCoverView.addSubview(item)
            }

        [profileImageView, ownedFeedStackView, contributedFeedStackView]
            .forEach { item in
                upperView.addSubview(item)
            }

        [numberOfOwnedFeedLabel, ownedFeedLabel]
            .forEach { item in
                ownedFeedStackView.addArrangedSubview(item)
            }

        [numberOfContributedFeedLabel, contributedFeedLabel]
            .forEach { item in
                contributedFeedStackView.addArrangedSubview(item)
            }

        applyConstraints()
    }

    private func applyConstraints(){

        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        let fullCoverViewConstraints = [
            fullCoverView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            fullCoverView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            fullCoverView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            fullCoverView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            fullCoverView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]

        let upperViewConstraints = [
            upperView.leadingAnchor.constraint(equalTo: fullCoverView.leadingAnchor, constant: leadingPadding),
            upperView.trailingAnchor.constraint(equalTo: fullCoverView.trailingAnchor, constant: trailingPadding),
            upperView.topAnchor.constraint(equalTo: fullCoverView.topAnchor),
            upperView.heightAnchor.constraint(equalToConstant: upperBarHeight),
        ]

        let profileImageViewConstraints = [
            profileImageView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: upperView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: upperBarHeight),
            profileImageView.heightAnchor.constraint(equalToConstant: upperBarHeight),
        ]

        let contributedFeedStackViewConstraints = [
            contributedFeedStackView.heightAnchor.constraint(equalToConstant: indicatorHeight),
            contributedFeedStackView.widthAnchor.constraint(equalToConstant: indicatorWidth),
            contributedFeedStackView.trailingAnchor.constraint(equalTo: upperView.trailingAnchor),
            contributedFeedStackView.centerYAnchor.constraint(equalTo: upperView.centerYAnchor)
        ]

        let ownedFeedStackViewConstraints = [
            ownedFeedStackView.heightAnchor.constraint(equalToConstant: indicatorHeight),
            ownedFeedStackView.widthAnchor.constraint(equalToConstant: indicatorWidth),
            ownedFeedStackView.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
            ownedFeedStackView.trailingAnchor.constraint(equalTo: contributedFeedStackView.leadingAnchor, constant: trailingPadding)
        ]

        let segmentedControlConstraints = [
            segmentedControl.heightAnchor.constraint(equalToConstant: segmentedControlHeight),
            segmentedControl.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: leadingPadding),
            segmentedControl.leadingAnchor.constraint(equalTo: fullCoverView.leadingAnchor, constant: leadingPadding),
            segmentedControl.trailingAnchor.constraint(equalTo: fullCoverView.trailingAnchor, constant: trailingPadding)
        ]

        let feedCollectionViewConstraints = [
            feedCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: leadingPadding),
            feedCollectionView.bottomAnchor.constraint(equalTo: fullCoverView.bottomAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ]

        [
            scrollViewConstraints,
            fullCoverViewConstraints,
            upperViewConstraints,
            profileImageViewConstraints,
            contributedFeedStackViewConstraints,
            ownedFeedStackViewConstraints,
            segmentedControlConstraints,
            feedCollectionViewConstraints,
        ]
            .forEach { constraint in
                NSLayoutConstraint.activate(constraint)
            }
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Cell 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return feeds.count
    }

    // Cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserViewFeedCollectionViewCell.identifier, for: indexPath) as? UserViewFeedCollectionViewCell else { return UICollectionViewCell() }

        let feed = feeds[indexPath.row]

        cell.configure(with: feed)

        return cell
    }

    // on click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = UIViewController()
        vc.view.backgroundColor = .red

        navigationController?.pushViewController(vc, animated: true)
    }
}


//// MARK: SwiftUI - Preview 추가
//struct UserViewControllerPreView: PreviewProvider {
//    static var previews: some View {
//        UserViewController().userViewControllerToPreview()
//    }
//}
//
//
//#if DEBUG
//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        }
//    }
//
//    func userViewControllerToPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
