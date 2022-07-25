//
//  RecordButtonController.swift
//  Wavegram
//
//  Created by 김제필 on 7/25/22.
//

import Foundation
import UIKit

class RecordButtonController: UIViewController {
    @IBOutlet weak var recordButton: RecordButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toggleRecordingButton(_ sender: RecordButton) {
        print(recordButton.isRecording ? "Recording Started" : "Recording Ended")
    }
}
