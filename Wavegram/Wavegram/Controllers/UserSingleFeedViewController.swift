//
//  UserPageSingleViewController.swift
//  Wavegram
//
//  Created by eunji on 2022/07/30.
//

import UIKit

class UserSingleFeedViewController: UIViewController {
    
    private var currentFeed: Feed
    
    // NavigationBar의 subtitle
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.text = "게시물"
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = .systemGray6
        
        return subtitleLabel
    }()
    
    // Collection View
    private let singleFeedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let singleFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        singleFeedCollectionView.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
        singleFeedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        singleFeedCollectionView.backgroundColor = .systemBackground
        
        return singleFeedCollectionView
    }()

    
    init(feed: Feed) {
        self.currentFeed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        [
            subtitleLabel,
            singleFeedCollectionView
        ].forEach { view.addSubview($0) }

        configureNavBar()
        
        singleFeedCollectionView.delegate = self
        singleFeedCollectionView.dataSource = self
        
        applyConstraints(_model: currentFeed)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // Status Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // Navigation Bar
    private func configureNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        
        // title
        navigationItem.title = DataManager.loggedInUser.name
        
        // backButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    
    // Constarints
    private func applyConstraints(_model: Feed) {
        
        // subtitleLabel
        let subtitleLabelConstraints = [
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subtitleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        // collectionView
        let singleFeedCollectionViewConstraints = [
            singleFeedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            singleFeedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            // 390:23
            singleFeedCollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: view.frame.width * (23.0/390)),
            singleFeedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        [
            subtitleLabelConstraints,
            singleFeedCollectionViewConstraints
        ].forEach { NSLayoutConstraint.activate($0) }
        
    }
    
}

extension UserSingleFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // cell 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // Section 수 -> 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // cell data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier, for: indexPath) as? HomeFeedCollectionViewCell else {return UICollectionViewCell()}

        cell.viewController = self
        cell.configure(with: currentFeed)
        
        return cell
    }
    
     // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 350:525 = 70:105 = 14:21
        let width = collectionView.frame.width
        return CGSize(width: width, height:  width * (21.0/14.0))
    }
    
}

