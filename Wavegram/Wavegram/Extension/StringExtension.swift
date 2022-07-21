//
//  StringExtension.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/20.
//

import Foundation

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathComponent(path)
    }
}
