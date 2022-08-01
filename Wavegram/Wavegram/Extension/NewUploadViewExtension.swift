
//
//  NewUploadViewExtension.swift
//  Wavegram
//
//  Created by 김제필 on 7/31/22.
//

import Foundation
import UIKit
import AVFoundation

extension NewUploadViewController {
    func didRenderRecordingSpectrogram() {
        audioPowers = []
        renderingStartingPoint = soundWaveStartingPoint
        soundWaveRecordingBazierPath = UIBezierPath(rect: spectrogramView.bounds)
        recordSoundWaveLayer.path = soundWaveRecordingBazierPath?.cgPath
        soundWaveRecordingBazierPath?.lineWidth = soundWaveLineWidth
        recordSoundWaveLayer.lineWidth = soundWaveLineWidth
    }

    func didRenderPlayingSpectrogram() {
        spectrogramView.layer.addSublayer(recordSoundWaveLayer)
        renderingStartingPoint = soundWaveStartingPoint
        soundWavePlayingBazierPath = nil
        playSoundWaveLayer.setNeedsDisplay()
        soundWavePlayingBazierPath = UIBezierPath(rect: spectrogramView.bounds)
        playSoundWaveLayer.path = soundWavePlayingBazierPath?.cgPath
        soundWavePlayingBazierPath!.lineWidth = soundWaveLineWidth
        playSoundWaveLayer.lineWidth = soundWaveLineWidth
    }

    func startRunning() {

    }
}


// Float -> text 저장
// 코드 출처: https://stackoverflow.com/questions/64234225/how-to-save-a-float-array-in-swift-as-txt-file
extension Array {
    var bytes: [UInt8] { withUnsafeBytes { .init($0) } }
    var data: Data { withUnsafeBytes { .init($0) } }
}

extension ContiguousBytes {
    func object<T>() -> T { withUnsafeBytes { $0.load(as: T.self) } }
    func objects<T>() -> [T] { withUnsafeBytes { .init($0.bindMemory(to: T.self)) } }
}

