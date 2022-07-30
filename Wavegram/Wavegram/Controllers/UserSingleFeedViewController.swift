//
//  UserPageSingleViewController.swift
//  Wavegram
//
//  Created by eunji on 2022/07/30.
//

import UIKit

class UserSingleFeedViewController: UIViewController {
    
    private var currentFeed: Feed
    
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
        
        configureNavBar()
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
    
}
