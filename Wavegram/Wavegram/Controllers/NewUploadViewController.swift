//
//  NewUploadViewController.swift
//  Wavegram
//
//  Created by 김상현, 김제필 on 2022/07/20.
//


import UIKit
import AVFoundation
import SwiftUI

// MARK: UIViewController
class NewUploadViewController: UIViewController {
    var audioPlayer : AVAudioPlayer!
    var audioRecorder : AVAudioRecorder!
    let spectrogram = Spectrogram()
    let imagePicker = UIImagePickerController()
    private let maxTitleTextLength: Int = 20
    private let maxMemoTextLength: Int = 50
    private var isRecording: Bool = false
    private var isPlaying: Bool = false
    private let xButtonString: String = "x.circle"
    private let recordStartButton: String = "recordButton"
    private let recordStopButton: String = "stopButton"
    private let playStartButton: String = "playButton"
    private let playStopButton: String = "pauseButton"
    private lazy var imagegesture = UITapGestureRecognizer(target: self, action: #selector(onTapRepresentativeImage(_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        spectrogram.contentsGravity = .resize
        spectrogramView.layer.addSublayer(spectrogram)
        
        spectrogram.startRunning()
        
        self.setNavigationBar()
        // recordview에 서브뷰 추가
        [spectrogramView, playTimeLabel, recordToggleButton, playToggleButton].forEach{ self.recordView.addSubview($0) }
        // vc superview에 서브뷰 추가
        [representativeImageLabel, representativeImage, titleLabel, titleTextField, memoLabel, memoTextField, memoTextLengthLabel, recordLabel, recordView].forEach { self.view.addSubview($0) }
        titleTextField.delegate = self
        memoTextField.delegate = self
        imagePicker.delegate = self
        representativeImage.addGestureRecognizer(imagegesture)
        recordToggleButton.addTarget(self, action: #selector(onTapRecordButton), for: .touchUpInside)
        playToggleButton.addTarget(self, action: #selector(onTapPlayButton), for: .touchUpInside)
      
        guard let recordToggleButtonImage = UIImage(named: recordStartButton) else { return }
        guard let playToggleButtonImage = UIImage(named: playStartButton) else { return }
        recordToggleButton.setImage(recordToggleButtonImage, for: .normal)
        playToggleButton.setImage(playToggleButtonImage, for: .normal)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setConstraints()
            self.setTitleTextFieldBorder()

            guard let xCircleImage = UIImage(systemName: self.xButtonString) else { return }
            self.titleTextField.setClearButton(with: xCircleImage, mode: .always)
            self.memoTextField.setClearButton(with: xCircleImage, mode: .always)
            // spectrogram layer 활성화를 위한 frame 주기
            self.spectrogram.frame = CGRect(x: 0, y: 0, width: self.recordView.bounds.width - 20, height: self.recordView.bounds.height * 0.3)
        }
    }
    
    private let memoTextLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(7/30)"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    private let representativeImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "Image *")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: "Image *").range(of: "Image"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: "Image *").range(of: "*"))
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    private let representativeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Title *")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: "Title *").range(of: "Title"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: "Title *").range(of: "*"))
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.text = "우럭먹다 받은 영감"
        textField.textColor = .white
        textField.clearButtonMode = .whileEditing

        return textField
    }()

    private let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Memo"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    private let memoTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.text = "우럭과 블루스"
        textField.textColor = .white

        return textField
    }()

    private let recordLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Recording *")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: "Recording *").range(of: "Recording"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: "Recording *").range(of: "*"))
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let recordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let playTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        label.text = "03:15"
        
        return label
    }()
    
    // 스펙트로그램 보여질 뷰
    private let spectrogramView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let recordToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .red

        return button
    }()

    private let playToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .red

        return button
    }()

    private func setNavigationBar() {
        self.navigationItem.title = "게시물 업로드"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onTapLeftBarButtonItem))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTapRightBarButtonItem))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setTitleTextFieldBorder() {
        self.titleTextField.layer.addBorder([.bottom], color: .white, width: 1)
        self.memoTextField.layer.addBorder([.bottom], color: .white, width: 1)
    }
//
//    private func setRecordToggleButtonBorder() {
//        recordToggleButton.layer.borderColor = UIColor.gray.cgColor
//        recordToggleButton.layer.borderWidth = 5
//        recordToggleButton.layer.cornerRadius = recordToggleButton.frame.width * 0.5
//    }

    // MARK: SetConstraints
    private func setConstraints() {
        let recordLabelConstraints = [
            recordLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            recordLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        let recordViewConstraints = [
            recordView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            recordView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            recordView.topAnchor.constraint(equalTo: recordLabel.bottomAnchor, constant: 15),
        ]
        let playTimeLabelConstraints = [
            playTimeLabel.centerXAnchor.constraint(equalTo: recordView.centerXAnchor),
            playTimeLabel.topAnchor.constraint(equalTo: recordView.topAnchor, constant: 10)
        ]
        let spectrogramViewConstraints = [
            spectrogramView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
            spectrogramView.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
            spectrogramView.topAnchor.constraint(equalTo: playTimeLabel.bottomAnchor, constant: 10),
            spectrogramView.bottomAnchor.constraint(equalTo: recordToggleButton.topAnchor, constant: -10)
        ]
        let recordToggleButtonConstraints = [
            recordToggleButton.trailingAnchor.constraint(equalTo: recordView.centerXAnchor, constant: -10),
            recordToggleButton.bottomAnchor.constraint(equalTo: recordView.bottomAnchor, constant: -35),
            recordToggleButton.widthAnchor.constraint(equalToConstant: 50),
            recordToggleButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        let playToggleButtonConstraints = [
            playToggleButton.leadingAnchor.constraint(equalTo: recordView.centerXAnchor, constant: 10),
            playToggleButton.bottomAnchor.constraint(equalTo: recordView.bottomAnchor, constant: -35),
            playToggleButton.widthAnchor.constraint(equalToConstant: 50),
            playToggleButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        let representativeImageLabelConstraints = [
            representativeImageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            representativeImageLabel.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 35)
        ]
        let representativeImageConstraints = [
            representativeImage.topAnchor.constraint(equalTo: representativeImageLabel.bottomAnchor, constant: 15),
            representativeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            representativeImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
            representativeImage.heightAnchor.constraint(equalTo: representativeImage.widthAnchor)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: representativeImage.bottomAnchor, constant: 35)
        ]
        let titleTextFieldConstraints = [
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
        ]
        let memoLabelConstraints = [
            memoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            memoLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 35)
        ]
        let memoTextFieldConstraints = [
            memoTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            memoTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            memoTextField.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 15),
        ]
        let memoTextLengthLabelConstraints = [
            memoTextLengthLabel.trailingAnchor.constraint(equalTo: memoTextField.trailingAnchor),
            memoTextLengthLabel.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 5),
            memoTextLengthLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        [representativeImageLabelConstraints,
         representativeImageConstraints,
         titleLabelConstraints,
         titleTextFieldConstraints,
         memoLabelConstraints,
         memoTextFieldConstraints,
         memoTextLengthLabelConstraints,
         recordLabelConstraints,
         recordViewConstraints,
         playTimeLabelConstraints,
         spectrogramViewConstraints,
         recordToggleButtonConstraints,
         playToggleButtonConstraints].forEach{ NSLayoutConstraint.activate($0) }
    }

    // MARK: OnTapGesture
    @objc func onTapRepresentativeImage(_ sender: UITapGestureRecognizer) {
        let alert =  UIAlertController(title: "사진을 골라주세요", message: "", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @objc func onTapLeftBarButtonItem() {
//        self.dismiss(animated: false)
        print("onTapLeftBarButtonItem")
    }

    @objc func onTapRightBarButtonItem() {
        print("onTapRightBarButtonItem")
    }
}

// MARK: UITextFieldDelegate
extension NewUploadViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as? NSString else { return false }
        let newText = text.replacingCharacters(in: range, with: string)

        guard textField.isEqual(memoTextField) else {
            guard newText.count > maxTitleTextLength else { return true }
            return false
        }

        guard newText.count > maxMemoTextLength else {
            memoTextLengthLabel.text = "(\(newText.count)/\(maxMemoTextLength))"
            return true
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewUploadViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @objc func onTapRecordButton() {
        switch isRecording {
        case true:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.recordStartButton) else { return }
                self.recordToggleButton.setImage(playToggleButtonImage, for: .normal)
                self.isRecording.toggle()
            }

            if let record = self.audioRecorder {
                record.stop()
                let session = AVAudioSession.sharedInstance()
                do{
                    try session.setActive(false)
                }
                catch{
                    print("\(error)")
                }
            }

        case false:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.recordStopButton) else { return }
                self.recordToggleButton.setImage(playToggleButtonImage, for: .normal)
                self.isRecording.toggle()
            }

            let session = AVAudioSession.sharedInstance()

            do{
                try session.setCategory(AVAudioSession.Category.playAndRecord)
                try session.setActive(true)
                session.requestRecordPermission({ (allowed : Bool) -> Void in
                    if allowed {
                        self.startRecording()
                    }
                    else{
                        print("녹음 권한 없음")
                    }
                })
            }
            catch{
                print("\(error)")
            }
        }
    }

    @objc func onTapPlayButton() {
        switch isPlaying {
        case true:
            guard let playToggleButtonImage = UIImage(named: playStartButton) else { return }
            self.playToggleButton.setImage(playToggleButtonImage, for: .normal)
                        
            self.isPlaying.toggle()
            guard let player = self.audioPlayer else { return }
            player.stop()

        case false:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.playStopButton) else { return }
                self.playToggleButton.setImage(playToggleButtonImage, for: .normal)
                
                self.isPlaying.toggle()
                if let data = NSData(contentsOfFile: self.audioFilePath()) {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: data as Data)
                        self.audioPlayer.delegate = self
                        self.audioPlayer.volume = 100
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.play()
                        print("Audio 재생")
                    }
                    catch {
                        print("\(error)")
                    }
                }
            }
        }
    }

    func startRecording(){
        do{
            let fileURL = NSURL(string: self.audioFilePath())!
            self.audioRecorder = try AVAudioRecorder(url: fileURL as URL, settings: self.audioRecorderSettings())
            
            if let recorder = self.audioRecorder {
                recorder.delegate = self
                
                if recorder.record() && recorder.prepareToRecord() {
                    print("녹음 시작 성공")
                }
            }
        }
        catch{
            print("\(error)")
        }
    }

    func audioFilePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let filePath = path.stringByAppendingPathComponent(path: "test.m4a") as String
        
        return filePath
    }

    func audioRecorderSettings() -> [String : AnyObject] {
        let settings = [AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)), AVSampleRateKey : NSNumber(value: Float(16000.0)), AVNumberOfChannelsKey : NSNumber(value: 1), AVEncoderAudioQualityKey : NSNumber(value: Int64(AVAudioQuality.high.rawValue))]
        
        return settings
    }

    //MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            print("Player 재생완료 성공")
            guard let playToggleButtonImage = UIImage(named: playStartButton) else { return }
            self.playToggleButton.setImage(playToggleButtonImage, for: .normal)
            self.isPlaying = false
        }
        else{
            print("Player 오류")
        }
    }

    //MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            print("녹음 완료 성공")
            print(recorder.url)
        }
        else{
            print("녹음 실패 종료")
        }
    }
}

// MARK: Imagepicker Delegate
extension NewUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            representativeImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
