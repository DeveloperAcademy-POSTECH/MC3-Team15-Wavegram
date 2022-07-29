//
//  FeedModel.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/18.
//

import Foundation

struct Feed: Hashable, Codable, Identifiable {

    let id: Int
    let owner: User
    let contributor: User?
    let title: String
    let description: String?
    let imageName: String?
    let audioName: String?
    
    var isOriginal: Bool {
        contributor == nil
    }
}
