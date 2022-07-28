//
//  DataManager.swift
//  Wavegram
//
//  Created by Kim Insub on 2022/07/28.
//

import Foundation

struct DataManager {

    static var shared = DataManager()

    let user: User = User(name: "woody", profileImage: "woodyProfileImage")

    private lazy var feeds: [Feed] = Array(repeating: Feed(id: 1001, owner: user, contributor: nil, title: "some title", description: "some description", imageName: "someImage", audioName: "someAudio"), count: 50)

    mutating func fetchData(currentPage: Int, completion: @escaping (Result<([Feed], Bool), Error>) -> Void) {

        let lastPage = self.feeds.count

        guard currentPage < lastPage else { return }

        // if First
        if currentPage == 0 {
            guard 0 < lastPage else { return }

            if 12 < lastPage {
                let result = Array(self.feeds[0...11])
                completion(.success((result, true)))
            } else {
                let result = Array(self.feeds[0...(lastPage - 1)])
                completion(.success((result, false)))
            }
        }

        // if more
        if currentPage > 0 {
            if currentPage + 9 < lastPage {
                let result = Array(self.feeds[currentPage...currentPage + 8])
                completion(.success((result, true)))
            } else {
                let result = Array(self.feeds[currentPage...lastPage - 1])
                completion(.success((result, false)))
            }
        }
    }
}
