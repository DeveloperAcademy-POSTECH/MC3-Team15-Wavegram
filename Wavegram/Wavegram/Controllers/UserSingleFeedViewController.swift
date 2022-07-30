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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}
