//
//  HomeViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: SwiftUI - Preview 추가
struct HomeViewControllerPreView: PreviewProvider {
    static var previews: some View {
        HomeViewController().homeViewControllerToPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func homeViewControllerToPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
