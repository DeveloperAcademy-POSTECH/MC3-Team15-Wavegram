//
//  File.swift
//  OsungTS-MC3
//
//  Created by Kim Insub on 2022/07/12.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}
