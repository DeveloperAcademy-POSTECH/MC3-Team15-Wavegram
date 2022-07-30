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
        
        navigationItem.title = DataManager.loggedInUser.name
        
        [
            subtitleLabel
        ].forEach { view.addSubview($0) }

        configureNavBar()
        applyConstraints(_model: currentFeed)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // Navigation Bar
    private func configureNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        
        // backButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    // Constarints
    private func applyConstraints(_model: Feed) {
        
        // subtitleLabel
        let subtitleConstraints = [
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subtitleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        NSLayoutConstraint.activate(subtitleConstraints)
    }
    
}
