//
//  FeedCollectionViewCell.swift
//  Wavegram
//
//  Created by eunji on 2022/07/25.
//

import UIKit
import AVFoundation

class HomeFeedCollectionViewCell: UICollectionViewCell {
    
    var feeds: Feed?
    weak var viewController: UIViewController?
    
    // Profile Image
    // TODO: UIIMageView -> UIButton
    private let profileImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // UserName
    private let userName: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        label.textAlignment = .left
        
        return label
    }()
    
    // originLabel
    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // originButton
    private let originButton: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToOriginFeed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func moveToOriginFeed() {
        // TODO: Move to the Original Feed / People
        print("Move to Original Feed / People")
    }
    
    // AdditionalButton
    private let additionalButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
                
        return button
    }()
    
    // Contribute Button
    @objc func uploadContributeFeed() {
        // TODO: Move to UploadContributeFeed
        print("Move to uploadContributeFeed View")
    }
    
    // ActionSheet
    @objc func displayActionSheet(_sender: UIButton!) {
        // TODO: Change AlertAction Font Size

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modify = UIAlertAction(title: "수정하기", style: .default) { action in
            // let vc = ModifyPost()
            // self.present(vc)
            print("수정하기")
        }
        let delete = UIAlertAction(title: "삭제하기", style: .destructive) { action in
            print("삭제하기")
        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel) { action in
            print("취소하기")
        }
        
        actionSheet.addAction(modify)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        viewController?.present(actionSheet, animated: true)
    }
    
    // 하단
    // rectangle
    private let rectangle: UIView = {
        
        let rect = UIView()
        rect.layer.borderWidth = 1
        rect.layer.backgroundColor = UIColor.clear.cgColor
        rect.layer.borderColor = UIColor.white.cgColor
        rect.translatesAutoresizingMaskIntoConstraints = false
        
        return rect
    }()
    
    // feedImage
    private let feedImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    // detail
    private let detailLabel: UILabel = {
        
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // feedImageGesture
    @objc func gestureFired(_ sender: UITapGestureRecognizer) {
        
        // TODO: adjust Alpha -> adjust color Gradation
        sender.view?.alpha = (sender.view?.alpha == 1) ? 0.3 : 1
        guard let feeds = feeds else {
            return
        }

        if feedImage.alpha == 1 {
            detailLabel.text = ""
        } else {
            detailLabel.text = feeds.description
        }
    }
    
    // titlelabel
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // contributorLabel
    private let contributorLabel: UILabel = {

        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    // Audio
    let player = AVPlayer()
    var play: Bool = false
    
    // Play & Pause Button
    let playButton: UIButton = {
        
        // TODO: Change playButton Font Size
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(play(_sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc func play(_sender: UIButton!) {
        play.toggle()
        
        if play {
            player.play()
            print("PLAY")
            _sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            print("PAUSE")
            _sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    let timeSlider: UISlider = {
        
        let slider = UISlider()
        slider.addTarget(self, action: #selector(toggleIsSeeking), for: .editingDidBegin)
        slider.addTarget(self, action: #selector(toggleIsSeeking), for: .editingDidEnd)
        slider.addTarget(self, action: #selector(seek(_sender:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        return slider
    }()
    
    @objc func toggleIsSeeking() {
        isSeeking.toggle()
    }
    
    @objc func seek(_sender: UISlider!) {
        
        guard let currentItem = player.currentItem else { return }
        let position = Double(_sender.value)
        let seconds = position * currentItem.duration.seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        
        player.seek(to: time)
    }
    
    var isSeeking: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        rectangle.frame = frame
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        feedImage.addGestureRecognizer(gestureRecognizer)
        
        [
            profileImage, userName,
            originLabel, originButton,
            additionalButton,
            rectangle,
            feedImage, detailLabel,
            titleLabel, contributorLabel,
            playButton, timeSlider
        ].forEach { addSubview($0) }
        
        
    }
    
    // Basic Setting
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Configure
    public func configure(with model: Feed) {
        self.feeds = model
        
        // profileImage and userName
        if model.isOriginal {
            profileImage.image = UIImage(named: model.owner.profileImage)
            userName.text = model.owner.name
        } else {
            guard let profileImageString = model.contributor?.profileImage else {return}
            profileImage.image = UIImage(named: profileImageString)
            userName.text = model.contributor?.name
        }
        
        // Origin Label and Button
        if model.isOriginal {
            originLabel.text = ""
        } else {
            originLabel.text = "Begin by"
            originButton.setTitle(model.owner.name, for: .normal)
        }
        
        // Additional Button
        let isMine = model.contributor?.name == "woody_." || model.contributor == nil
        let buttonSymbolName = isMine ? "ellipsis" : "rectangle.stack.badge.plus"
        additionalButton.setImage(UIImage(systemName: buttonSymbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        
        if isMine {
            additionalButton.addTarget(self, action: #selector(displayActionSheet(_sender:)), for: .touchUpInside)
        } else {
            additionalButton.addTarget(self, action: #selector(uploadContributeFeed), for: .touchUpInside)
        }
        
        // feedImage
        feedImage.image = UIImage(named: model.imageName ?? "someImage")
        
        // titleLabel
        titleLabel.text = model.title
        
        // contributorLabel
        if model.contributor == nil {
            contributorLabel.text = model.owner.name
        } else {
            contributorLabel.text = model.owner.name + ", " + model.contributor!.name
        }
        
        applyConstraints(model)
        
        configurePlayer(model.audioName)
        
        configureObserver()
    }
    
    // Constraints
    private func applyConstraints(_ model: Feed) {
        let r = frame.width * 21.0 / 175.0 // ProfileImage 반지름
        let w = rectangle.frame.width * (33.0 / 35.0) // FeedImage Width
        let x = rectangle.frame.height / 17.5 // FeedImage TopAnchor
        
        let profileImageConstraints = [
            profileImage.topAnchor.constraint(equalTo: topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            // 42: 350 = 21:175
            profileImage.heightAnchor.constraint(equalToConstant: r),
            profileImage.widthAnchor.constraint(equalToConstant: r)
        ]
        
        var userNameConstraints = [
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
            userName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ]
        
        if !model.isOriginal {
            userNameConstraints = [
                userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
                userName.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            ]
        }
        
        let originLabelConstraints = [
            originLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4.96),
            originLabel.topAnchor.constraint(equalTo: userName.bottomAnchor),
            originLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor)
        ]
        
        let originButtonConstraints = [
            originButton.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: 4),
            originButton.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor)
        ]
        
        let additionalButtonConstraints = [
            additionalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            additionalButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
        ]
        
        // 하단
        let rectangleConstraints = [
            // 350:476
            rectangle.leadingAnchor.constraint(equalTo: leadingAnchor),
            rectangle.trailingAnchor.constraint(equalTo: trailingAnchor),
            rectangle.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 6.82),
            rectangle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let feedImageConstraints = [
            // image width: 350: 330 = 35:33
            // topAnchor: 350:20 = 17.5:1
            feedImage.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
            feedImage.widthAnchor.constraint(equalToConstant: w),
            feedImage.heightAnchor.constraint(equalToConstant: w),
            
            feedImage.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: x)
        ]
        
        let detailLabelConstraints = [
            detailLabel.centerXAnchor.constraint(equalTo: feedImage.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: feedImage.centerYAnchor),
            
            // TODO: Change detailLabel Length as the Design
            detailLabel.leadingAnchor.constraint(equalTo: feedImage.leadingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: feedImage.trailingAnchor, constant: -10)
        ]
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
            // topAnchor: 476:14 = 238:7
            titleLabel.topAnchor.constraint(equalTo: feedImage.bottomAnchor, constant: rectangle.frame.height * (7.0 / 238.0))
        ]
        
        let contributorConstraints = [
            contributorLabel.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
            // width: 350:250 = 7:5
            contributorLabel.widthAnchor.constraint(equalToConstant: rectangle.frame.width * (5.0 / 7.0)),

            contributorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rectangle.frame.height * (10.0 / 476.0))
        ]
        
        let playButtonConstraints = [
            // 350:16 = 175:8p
            playButton.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: rectangle.frame.width * (8.0 / 175.0)),
            playButton.widthAnchor.constraint(equalToConstant: 27),
            // 476:24 = 119:6
            playButton.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -rectangle.frame.height * (6.0 / 196))
        ]
        
        let timeSliderConstraints = [
            // 350: 14
            timeSlider.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -rectangle.frame.width * (14.0 / 350)),
            // 350 : 254
            timeSlider.widthAnchor.constraint(equalToConstant: rectangle.frame.width * (286.0 / 350)),
            timeSlider.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ]
        
        [
            profileImageConstraints,userNameConstraints,
            originLabelConstraints, originButtonConstraints,
            additionalButtonConstraints,
            rectangleConstraints,
            feedImageConstraints, detailLabelConstraints,
            titleLabelConstraints, contributorConstraints,
            playButtonConstraints, timeSliderConstraints
        ].forEach { NSLayoutConstraint.activate($0) }
        
    }
    
    // Audio 연결
    func configurePlayer(_ music: String) {
        guard let url = Bundle.main.url(forResource: music, withExtension: "mp3") else {
            print("Failed to Load Sound")
            return
        }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
    }
    
    // UISlider value 변경
    func updateTime() {

        let currentTime = self.player.currentItem?.currentTime().seconds ?? 0
        let totalTime = self.player.currentItem?.duration.seconds ?? 0

        if !isSeeking {
            self.timeSlider.value = Float(currentTime / totalTime)
        }
    }
    
    // Audio 음악 재생 구간 이동
    func configureObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 100)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] _ in
            self?.updateTime()
        }
    }
    
}
