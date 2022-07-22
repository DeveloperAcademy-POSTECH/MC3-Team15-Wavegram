//
//  SingleFeedViewController.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/19.
//

import UIKit
import SwiftUI

class SingleFeedViewController: UIViewController {

    private var currentFeed: Feed

    init(feed: Feed) {
        self.currentFeed = feed
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func configure(with feed: Feed) {

    }

}
