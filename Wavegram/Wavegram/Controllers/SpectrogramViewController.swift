//
//  ViewController.swift
//  Spectrogram
//
//  Created by 김제필 on 7/18/22.
//

import AVFoundation
import Accelerate
import UIKit

class SpectrogramViewController: UIViewController {

    // 스펙트로그램 레이어
    let spectrogram = Spectrogram()

    override func viewDidLoad() {
        super.viewDidLoad()

        spectrogram.contentsGravity = .resize
        view.layer.addSublayer(spectrogram)

        view.backgroundColor = .black

        spectrogram.startRunning()
    }

    override func viewDidLayoutSubviews() {
        spectrogram.frame = view.frame
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}
