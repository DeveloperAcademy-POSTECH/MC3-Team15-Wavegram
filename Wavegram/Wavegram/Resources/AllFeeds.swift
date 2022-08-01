//
//  AllFeeds.swift
//  Wavegram
//
//  Created by eunji on 2022/07/31.
//

import Foundation

var allFeeds: [Feed] = [
    
    Feed(id: 5, owner: User(name: "himheys_swag", profileImage: "drogbaProfile"), contributor: nil, title: "록바 스웩", description: "SWAG 충만", imageName: "drogbaFeed", audioName: "happyDay"),
    
    Feed(id: 4, owner: User(name: "alice_in_musicland", profileImage: "aliceProfile"), contributor: User(name: "milky_rabbit", profileImage: "milkyProfile"), title: "나도몰라~", description: "나도 모르겠다~ 어떻게든 하겠지", imageName: "aliceFeed", audioName: "GuitarAndVocal"),
    
    Feed(id: 3, owner: User(name: "alice_in_musicland", profileImage: "aliceProfile"), contributor: nil, title: "아몰랑", description: "어떻게든 되겠지", imageName: "aliceFeed", audioName: "GuitarOnly"),
    
    Feed(id: 2, owner: User(name: "woody__.", profileImage: "woodyProfile"), contributor: User(name: "alice_in_musicland", profileImage: "aliceProfile"), title: "우럭 마시쏘", description: "우럭우러", imageName: "woodyFeed", audioName: "exampleFile"),
    
    Feed(id: 1, owner: User(name: "woody__.", profileImage: "woodyProfile"), contributor: nil, title: "우럭먹다 받은 영감", description: "우럭과 함꼐 블루스", imageName: "woodyFeed", audioName: "happyDay")
]
