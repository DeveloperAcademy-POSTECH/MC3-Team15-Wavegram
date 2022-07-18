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
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SeacrhViewController())
        let vc4 = UINavigationController(rootViewController: UserViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "music.note.house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "person.fill")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc4.title = "User"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc4], animated: true)
    }
    
}
