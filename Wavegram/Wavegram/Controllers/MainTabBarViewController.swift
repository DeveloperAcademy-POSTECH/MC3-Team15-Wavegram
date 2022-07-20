//
//  MainTabBarViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//
import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: NewUploadViewController())
        let vc2 = UINavigationController(rootViewController: SeacrhViewController())
        let vc3 = UINavigationController(rootViewController: UserViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "music.note.house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "person.fill")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "User"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
    
}
