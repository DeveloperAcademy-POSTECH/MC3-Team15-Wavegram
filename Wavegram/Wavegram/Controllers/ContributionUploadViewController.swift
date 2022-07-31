//
//  ContributionUploadViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/30.
//

import UIKit
import AVFoundation

class ContributionUploadViewController: UIViewController {
    private var audioPlayer : AVPlayer!
    private var audioRecorder : AVAudioRecorder!
    private let originalSpectrogram = Spectrogram()
    private let myTrackSpectrogram = Spectrogram()
    private let imagePicker = UIImagePickerController()
    private let scrollViewHeight: CGFloat = 900
    private let maxTitleTextLength: Int = 20
    private let maxMemoTextLength: Int = 50
    private var isRecording: Bool = false
    private var isPlaying: Bool = false
    private lazy var spectrogramFrame: CGRect = CGRect(x: 0, y: 0, width: self.recordView.frame.width - 20, height: self.recordView.frame.height * 0.2)
    private let speakerImageBound: CGRect = CGRect(x: 0, y: -3, width: 22.5, height: 18)
    private let speakerImageString: String = "speaker"
    private let mutedSpeakerImageString: String = "mutedSpeaker"
    private let xButtonString: String = "x.circle"
    private let recordStartButton: String = "recordButton"
    private let recordStopButton: String = "stopButton"
    private let playStartButton: String = "playButton"
    private let playStopButton: String = "pauseButton"
    private lazy var imagegesture = UITapGestureRecognizer(target: self, action: #selector(onTapRepresentativeImage(_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.backgroundColor = .black
            
            self.originalSpectrogram.contentsGravity = .resize
            self.originalSpectrogramView.layer.addSublayer(self.originalSpectrogram)
            self.myTrackSpectrogram.contentsGravity = .resize
            self.myTrackSpectrogramView.layer.addSublayer(self.myTrackSpectrogram)
            
            self.setNavigationBar()
            self.view.addSubview(self.scrollView)
            self.scrollView.addSubview(self.scrollContentView)
            // recordview에 서브뷰 추가
            [self.originalSpectrogramView, self.myTrackSpectrogramView, self.originalFeedTitleLabel, self.recordToggleButton, self.playToggleButton, self.originalMusicTitle, self.myTrackMusicTitle, self.originalMusicPlayTimeLabel].forEach{ self.recordView.addSubview($0) }
            // vc superview에 서브뷰 추가
            [self.representativeImageLabel, self.representativeImage, self.titleLabel, self.titleTextField, self.memoLabel, self.memoTextField, self.memoTextLengthLabel, self.recordLabel, self.recordView].forEach { self.scrollContentView.addSubview($0) }
        }
        titleTextField.delegate = self
        memoTextField.delegate = self
        imagePicker.delegate = self
        representativeImage.addGestureRecognizer(imagegesture)
        playToggleButton.addTarget(self, action: #selector(onTapRecordButton), for: .touchUpInside)
        recordToggleButton.addTarget(self, action: #selector(onTapPlayButton), for: .touchUpInside)
      
        guard let recordToggleButtonImage = UIImage(named: recordStartButton) else { return }
        guard let playToggleButtonImage = UIImage(named: playStartButton) else { return }
        recordToggleButton.setImage(recordToggleButtonImage, for: .normal)
        playToggleButton.setImage(playToggleButtonImage, for: .normal)
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
            self.originalSpectrogram.frame = CGRect(x: 0, y: 0, width: self.recordView.frame.width - 20, height: self.recordView.frame.height * 0.25)//self.spectrogramFrame
            self.myTrackSpectrogram.frame = CGRect(x: 0, y: 0, width: self.recordView.frame.width - 20, height: self.recordView.frame.height * 0.25)//self.spectrogramFrame
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    private let memoTextLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(7/30)"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag

        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
        imageView.layer.cornerRadius = 10
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
    
    private let originalFeedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.text = "우럭먹다 받은 영감"
        
        return label
    }()
    
    private lazy var originalMusicTitle: UILabel = {
        let label = UILabel()
        label.semanticContentAttribute = .forceRightToLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        let attributedString = self.retrieveSpeakerImageAttributedString("Original ", self.mutedSpeakerImageString)
        label.attributedText = attributedString
        label.autoresizesSubviews = true
        
        return label
    }()
    
    private lazy var myTrackMusicTitle: UILabel = {
        let label = UILabel()
        label.semanticContentAttribute = .forceRightToLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        let attributedString = self.retrieveSpeakerImageAttributedString("My Track ", self.mutedSpeakerImageString)
        label.attributedText = attributedString
        label.autoresizesSubviews = true

        return label
    }()
    
    private let originalMusicPlayTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        label.text = "00:00"
        
        return label
    }()
    
    // 스펙트로그램 보여질 뷰
    private let originalSpectrogramView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myTrackSpectrogramView: UIView = {
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
    
    private func setPlayTimeLabel() {
        self.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main, using: { time in
            if self.audioPlayer?.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds((self.audioPlayer?.currentTime())!)
                
                let secs = Int(currentTime)
                self.originalMusicPlayTimeLabel.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String
            }
        })
    }

    // MARK: SetConstraints
    private func setConstraints() {
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        let scrollContentViewConstraints = [
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalToConstant: scrollViewHeight)
          ]
        let recordLabelConstraints = [
            recordLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            recordLabel.topAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        let recordViewConstraints = [
            recordView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            recordView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            recordView.topAnchor.constraint(equalTo: recordLabel.bottomAnchor, constant: 15),
        ]
        let playMusicTitleLabelConstraints = [
            originalFeedTitleLabel.centerXAnchor.constraint(equalTo: recordView.centerXAnchor),
            originalFeedTitleLabel.topAnchor.constraint(equalTo: recordView.topAnchor, constant: 10)
        ]
        let originalMusicTitleConstraints = [
            originalMusicTitle.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 12),
            originalMusicTitle.topAnchor.constraint(equalTo: originalFeedTitleLabel.bottomAnchor, constant: 20)
        ]
        let myTrackMusicTitleConstraints = [
            myTrackMusicTitle.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 12),
            myTrackMusicTitle.topAnchor.constraint(equalTo: originalSpectrogramView.bottomAnchor, constant: 20)
        ]
        let originalSpectrogramViewConstraints = [
            originalSpectrogramView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
            originalSpectrogramView.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
            originalSpectrogramView.topAnchor.constraint(equalTo: originalMusicTitle.bottomAnchor, constant: 10),
            originalSpectrogramView.heightAnchor.constraint(equalTo: recordView.heightAnchor, multiplier: 0.25)
        ]
        let myTrackSpectrogramViewConstraints = [
            myTrackSpectrogramView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
            myTrackSpectrogramView.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
            myTrackSpectrogramView.topAnchor.constraint(equalTo: myTrackMusicTitle.bottomAnchor, constant: 10),
            myTrackSpectrogramView.heightAnchor.constraint(equalTo: recordView.heightAnchor, multiplier: 0.25)
        ]
        let originalMusicPlayTimeLabelConstraints = [
            originalMusicPlayTimeLabel.topAnchor.constraint(equalTo: originalSpectrogramView.bottomAnchor),
            originalMusicPlayTimeLabel.bottomAnchor.constraint(equalTo: myTrackMusicTitle.topAnchor),
            originalMusicPlayTimeLabel.centerXAnchor.constraint(equalTo: recordView.centerXAnchor)
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
            representativeImageLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            representativeImageLabel.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 35)
        ]
        let representativeImageConstraints = [
            representativeImage.topAnchor.constraint(equalTo: representativeImageLabel.bottomAnchor, constant: 15),
            representativeImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            representativeImage.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor, multiplier: 0.2),
            representativeImage.heightAnchor.constraint(equalTo: representativeImage.widthAnchor)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: representativeImage.bottomAnchor, constant: 35)
        ]
        let titleTextFieldConstraints = [
            titleTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
        ]
        let memoLabelConstraints = [
            memoLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            memoLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 35)
        ]
        let memoTextFieldConstraints = [
            memoTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            memoTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            memoTextField.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 15),
        ]
        let memoTextLengthLabelConstraints = [
            memoTextLengthLabel.trailingAnchor.constraint(equalTo: memoTextField.trailingAnchor),
            memoTextLengthLabel.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 5),
            memoTextLengthLabel.bottomAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        [scrollViewConstraints,
         scrollContentViewConstraints,
         representativeImageLabelConstraints,
         representativeImageConstraints,
         titleLabelConstraints,
         titleTextFieldConstraints,
         memoLabelConstraints,
         memoTextFieldConstraints,
         memoTextLengthLabelConstraints,
         recordLabelConstraints,
         recordViewConstraints,
         playMusicTitleLabelConstraints,
         originalMusicTitleConstraints,
         myTrackMusicTitleConstraints,
         originalMusicPlayTimeLabelConstraints,
         originalSpectrogramViewConstraints,
         myTrackSpectrogramViewConstraints,
         recordToggleButtonConstraints,
         playToggleButtonConstraints].forEach{ NSLayoutConstraint.activate($0) }
    }
    
    private func retrieveSpeakerImageAttributedString(_ title: String, _ imageName: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = self.speakerImageBound
        imageAttachment.image = UIImage(named: imageName)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        return attributedString
    }

    private func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        DispatchQueue.main.async {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let cons = self.scrollContentView.constraints.filter{$0.firstItem as! NSObject == self.scrollContentView && $0.firstAttribute == .bottom}
                cons.forEach{$0.constant = keyboardHeight}
            }
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification){
        DispatchQueue.main.async {
            let cons = self.scrollContentView.constraints.filter{$0.firstItem as! NSObject == self.scrollContentView && $0.firstAttribute == .bottom}
            cons.forEach{$0.constant = 0}
        }
    }
}

// MARK: UITextFieldDelegate
extension ContributionUploadViewController: UITextFieldDelegate {
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

extension ContributionUploadViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    // MARK: Original Play
    @objc func onTapRecordButton() {
        switch isRecording {
        case true:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.playStartButton) else { return }
                self.playToggleButton.setImage(playToggleButtonImage, for: .normal)
                self.isRecording.toggle()
            }
            self.originalSpectrogram.stopRunning()
            self.originalMusicTitle.attributedText = self.retrieveSpeakerImageAttributedString("Original ", self.mutedSpeakerImageString)
            guard let player = self.audioPlayer else { return }
            player.pause()
            
        case false:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.playStopButton) else { return }
                self.playToggleButton.setImage(playToggleButtonImage, for: .normal)
                self.isRecording.toggle()
            }
            self.originalSpectrogram.startRunning()
            self.originalMusicTitle.attributedText = self.retrieveSpeakerImageAttributedString("Original ", self.speakerImageString)
            if let musicURL = Bundle.main.url(forResource: "GuitarOnly", withExtension: "mp3") {
                self.audioPlayer = AVPlayer(url: musicURL)
                self.audioPlayer.volume = 1
                self.audioPlayer.play()
                print("오디오 재생")
            }
            self.setPlayTimeLabel()
        }
    }
    // MARK: My Track Play
    @objc func onTapPlayButton() {
        switch isPlaying {
        case true:
            guard let playToggleButtonImage = UIImage(named: recordStartButton) else { return }
            self.recordToggleButton.setImage(playToggleButtonImage, for: .normal)
                        
            self.isPlaying.toggle()
            guard let player = self.audioPlayer else { return }
            player.pause()
            self.myTrackSpectrogram.stopRunning()
            self.myTrackMusicTitle.attributedText = self.retrieveSpeakerImageAttributedString("My Track ", self.mutedSpeakerImageString)
        case false:
            DispatchQueue.main.async {
                guard let playToggleButtonImage = UIImage(named: self.recordStopButton) else { return }
                self.recordToggleButton.setImage(playToggleButtonImage, for: .normal)
                
                self.isPlaying.toggle()
                self.myTrackSpectrogram.startRunning()
                self.myTrackMusicTitle.attributedText = self.retrieveSpeakerImageAttributedString("My Track ", self.speakerImageString)
                if let musicURL = Bundle.main.url(forResource: "GuitarAndVocal", withExtension: "mp3") {
                    self.audioPlayer = AVPlayer(url: musicURL)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.play()
                    print("오디오 재생")
                }
//                self.setPlayTimeLabel()
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
}

// MARK: Imagepicker Delegate
extension ContributionUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

// MARK: UIScrollViewDelegate
extension ContributionUploadViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
