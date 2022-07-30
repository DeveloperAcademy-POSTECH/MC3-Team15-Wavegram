//
//  MainTabBarViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//
import UIKit
//import SwiftUI

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ContributionUploadViewController())
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


//// MARK: SwiftUI - Preview 추가
//struct MainTabBarViewControllerPreView: PreviewProvider {
//    static var previews: some View {
//        MainTabBarViewController().uiViewControllerToPreview()
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
//    func uiViewControllerToPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
