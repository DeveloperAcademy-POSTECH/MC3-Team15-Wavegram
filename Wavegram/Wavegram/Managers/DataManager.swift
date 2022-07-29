//
//  DataManager.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/28.
//

import Foundation

struct DataManager {

    static var shared = DataManager()

    static let loggedInUser = User.loggedInUser

    private let jsonManager = JsonManager()

    private lazy var userOwnedFeeds: [Feed] = jsonManager.load("UserOwnedFeeds.json")

    private lazy var userContributedFeeds: [Feed] = jsonManager.load("UserContributedFeeds.json")

    mutating func requestUserOwnedFeeds(currentPage: Int, completion: @escaping (Result<([Feed], Bool), Error>) -> Void) {

        let lastPage = self.userOwnedFeeds.count

        guard currentPage < lastPage else { return }

        // if First
        if currentPage == 0 {
            guard 0 < lastPage else { return }

            if 12 < lastPage {
                let result = Array(self.userOwnedFeeds[0...11])
                completion(.success((result, true)))
            } else {
                let result = Array(self.userOwnedFeeds[0...(lastPage - 1)])
                completion(.success((result, false)))
            }
        }

        // if more
        if currentPage > 0 {
            if currentPage + 9 < lastPage {
                let result = Array(self.userOwnedFeeds[currentPage...currentPage + 8])
                completion(.success((result, true)))
            } else {
                let result = Array(self.userOwnedFeeds[currentPage...lastPage - 1])
                completion(.success((result, false)))
            }
        }
    }
}
