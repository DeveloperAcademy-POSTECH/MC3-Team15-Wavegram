//
//  FontExtension.swift
//  Wavegram
//
//  Created by 김제필 on 7/25/22.
//

import Foundation
import SwiftUI
import UIKit


/*
  Font 타입의 프로퍼티가 존재하는 클래스에는 모두 사용할 수 있다.

  MARK: 사용법
  예시 1) label.font = .mainFeedUserID
  예시 2) textField.font = .mainFeedUserID
*/


extension UIFont {
    static var headerID: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    static var headerTitle: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .medium)
    }

    static var headerButton: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    static var bodyTitle: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    static var bodyTitleInactive: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    static var bodyContents: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    static var bodyContentsSmall: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
}
