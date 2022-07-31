//
//  UserViewController.swift
//  OsungTS-MC3
//
//  Created by Kim Insub on 2022/07/12.
//

import UIKit

class UserViewController: UIViewController {

    let user = DataManager.loggedInUser

    lazy var feeds: [Feed] = []
    private var currentPage: Int = 0
    private var hasNextPage: Bool = true
    private var isLoading: Bool = false

    // Feed Collection View
    private let feedCollectionView: UICollectionView = {
        let surfaceLength = UIScreen.main.bounds.width / 3

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: surfaceLength, height: surfaceLength)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(UserFeedCollectionViewCell.self, forCellWithReuseIdentifier: UserFeedCollectionViewCell.identifier)
        collectionView.register(UserFeedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserFeedCollectionReusableView.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self

        DataManager.shared.requestUserOwnedFeeds(currentPage: currentPage) { [weak self] result in

            switch result {
            case .success(let response):

                self?.feeds.append(contentsOf: response.0)
                self?.currentPage = (self?.feeds.count) ?? 0
                self?.hasNextPage = response.1

                DispatchQueue.main.async {
                    self?.feedCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        configureNavbar()
        configureView()
        applyConstraints()
    }
}

extension UserViewController {

    // Configure Nav Bar
    private func configureNavbar() {

        // user name
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        leftButton.setTitle(user.name, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let leftButtonItem = UIBarButtonItem(customView: leftButton)

        // plus button
        let image = UIImage(systemName: "plus.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light))
        let rightButton = UIButton(type: .system)
        rightButton.setImage(image, for: .normal)
        rightButton.addTarget(self, action: #selector(uploadNewFeed), for: .touchUpInside)
        let rightButtonItem = UIBarButtonItem(customView: rightButton)

        rightButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true

        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.tintColor = .white
    }

    private func configureView() {
        [feedCollectionView]
            .forEach { item in
                view.addSubview(item)
            }
    }
    private func applyConstraints() {
        let feedCollectionViewConstraints = [
            feedCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            feedCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        [feedCollectionViewConstraints]
            .forEach { item in
                NSLayoutConstraint.activate(item)
            }
    }

    @objc private func uploadNewFeed() {
        let vc = NewUploadViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: false)
//        self.present(vc, animated: false)
        print("Move To Upload Feed View")
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Section 당 Cell 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    // Cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserFeedCollectionViewCell.identifier, for: indexPath) as? UserFeedCollectionViewCell else { return UICollectionViewCell() }

        let feed = feeds[indexPath.row]

        cell.configure(with: feed)

        return cell
    }

    // Cell 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = UIViewController()
        vc.view.backgroundColor = .red

        navigationController?.pushViewController(vc, animated: true)
    }

    // header 생성
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserFeedCollectionReusableView.identifier, for: indexPath) as? UserFeedCollectionReusableView else { return UICollectionReusableView() }

        header.configure(with: user)

        return header
    }

    // header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 192)
    }
}

extension UserViewController: UIScrollViewDelegate {

    // if user scrolled over bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (feedCollectionView.contentSize.height - scrollView.frame.size.height + 120) < position {

            guard !isLoading else { return }

            isLoading = true

            DataManager.shared.requestUserOwnedFeeds(currentPage: currentPage) { [weak self] result in
                switch result {
                case .success(let response):

                    self?.feeds.append(contentsOf: response.0)
                    self?.currentPage = (self?.feeds.count) ?? 0
                    self?.hasNextPage = response.1
                    DispatchQueue.main.async {
                        self?.feedCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

            isLoading = false
        }
    }
}
