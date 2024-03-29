//
//  HomeViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    private var feeds = allFeeds
    
    // Collection View
    private let feedCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feedCollectionView.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedCollectionView.backgroundColor = .systemBackground
        return feedCollectionView
    }()
    
    // NavigationBar
    private func configureNavbar() {
        
        // Logo
        let logoButton = UIButton()
        logoButton.frame = CGRect(x: 0, y: 0, width: 120, height: 28)
        logoButton.setTitle("MIX TAPE", for: .normal)
        logoButton.titleLabel?.font = UIFont(name: "RockSalt", size: 18)
        
        // NavBar Left
        let leftBarButtonItem = UIBarButtonItem(customView: logoButton)
        let leftWidth = leftBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 120)
            leftWidth?.isActive = true
        let leftHeight = leftBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 28)
            leftHeight?.isActive = true
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Button
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light)), for: .normal)
        addButton.addTarget(self, action: #selector(uploadNewFeed), for: .touchUpInside)
        
        // NavBar Right
        let rightBarButtonItem = UIBarButtonItem(customView: addButton)
        rightBarButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        let rightHeight = rightBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30)
            rightHeight?.isActive = true
        let rightWidth = rightBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30)
            rightWidth?.isActive = true
        // TODO: rightBarButton Trailing Padding
        

        navigationItem.rightBarButtonItem = rightBarButtonItem

        navigationController?.navigationBar.tintColor = .white
    }
    
    // NavBar Right Button Function
    @objc func uploadNewFeed() {
        let vc = NewUploadViewController()
//        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: false)
        print("Move To Upload Feed View")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.feeds = allFeeds
        self.feedCollectionView.reloadData()
    }
    
    // viewLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(feedCollectionView)

        feedCollectionView.showsHorizontalScrollIndicator = false
        feedCollectionView.showsVerticalScrollIndicator = false
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        applyConstraints()
        configureNavbar()
    }
    
    // Subview
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // Constraints
    private func applyConstraints() {
        
        let feedCollectionViewConstraints = [
            feedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            feedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // TODO: NavigationBarItem TopAnchor: 20 -> have to fix to ratio
            feedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(feedCollectionViewConstraints)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단 빈 공간
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return inset
    }
    
    // cell 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    // Section 수 -> 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // cell data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier, for: indexPath) as? HomeFeedCollectionViewCell else {return UICollectionViewCell()}

        let feed = feeds[indexPath.row]
        cell.viewController = self
        cell.configure(with: feed)
        
        return cell
    }
    
     // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 350:525 = 70:105 = 14:21
        let width = collectionView.frame.width
        return CGSize(width: width, height:  width * (21.0/14.0))
    }
    
    // cell distance
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //390:50 = 39:5
        let width = collectionView.frame.width
        let height = width * (5.0 / 39.0)
        return height
    }
    
}
