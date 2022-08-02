//
//  ModifyPostViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//

import UIKit
import SwiftUI

// MARK: UIViewController
class ModifyPostViewController: UIViewController {
    var feed: Feed? = nil
    private let maxTitleTextLength: Int = 20
    private let maxMemoTextLength: Int = 50
    private let xButtonString: String = "x.circle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        [representativeImageLabel, representativeImage, titleLabel, titleTextField, memoLabel, memoTextField, memoTextLengthLabel].forEach { self.view.addSubview($0) }
        titleTextField.delegate = self
        memoTextField.delegate = self
        self.titleTextField.text = self.feed?.title
        self.memoTextField.text = self.feed?.description
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [self] in
            self.view.backgroundColor = .black
            self.setConstraints()
            self.setTitleTextFieldBorder()
            representativeImage.image = UIImage(named: (self.feed?.imageName)!)

            guard let xCircleImage = UIImage(systemName: self.xButtonString) else { return }
            titleTextField.setClearButton(with: xCircleImage, mode: .always)
            memoTextField.setClearButton(with: xCircleImage, mode: .always)
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
        label.text = "대표 이미지"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private let representativeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "제목 *")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: "제목 *").range(of: "제목"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: "제목 *").range(of: "*"))
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.text = ""
        textField.textColor = .white
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메모"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private let memoTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.text = ""
        textField.textColor = .white

        return textField
    }()
    
    private func setNavigationBar() {
        self.navigationItem.title = "게시물 수정"
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
    
    // MARK: SetConstraints
    private func setConstraints() {
        let representativeImageLabelConstraints = [
            representativeImageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            representativeImageLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        let representativeImageConstraints = [
            representativeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            representativeImage.topAnchor.constraint(equalTo: representativeImageLabel.bottomAnchor, constant: 10),
            representativeImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
            representativeImage.heightAnchor.constraint(equalTo: representativeImage.widthAnchor)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: representativeImage.bottomAnchor, constant: 50)
        ]
        let titleTextFieldConstraints = [
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),

        ]
        let memoLabelConstraints = [
            memoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            memoLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20)
        ]
        let memoTextFieldConstraints = [
            memoTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            memoTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            memoTextField.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 10),

        ]
        let memoTextLengthLabelConstraints = [
            memoTextLengthLabel.trailingAnchor.constraint(equalTo: memoTextField.trailingAnchor),
            memoTextLengthLabel.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 5)
        ]
        
        [representativeImageLabelConstraints, representativeImageConstraints, titleLabelConstraints, titleTextFieldConstraints, memoLabelConstraints, memoTextFieldConstraints, memoTextLengthLabelConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
    
    // MARK: OnTapGesture
    @objc func onTapLeftBarButtonItem() {
        self.navigationController?.popViewController(animated: false)
        print("onTapLeftBarButtonItem")
    }
    
    @objc func onTapRightBarButtonItem() {
        self.navigationController?.popViewController(animated: false)
        guard let id = self.feed?.id else {return}
        guard let owner = self.feed?.owner else {return}
        let contributor = self.feed?.contributor
        guard let title = self.titleTextField.text else {return}
        let description = self.memoTextField.text
        let imageName = self.feed?.imageName
        let audioName = self.feed?.audioName
        
        let feed = Feed(id: id, owner: owner, contributor: contributor, title: title, description: description, imageName: imageName, audioName: audioName)
        guard let unModifiedFeedIndex = allFeeds.firstIndex(of: self.feed!) else {return}
        allFeeds[unModifiedFeedIndex] = feed
        
        print("onTapRightBarButtonItem")
    }
}

// MARK: UITextFieldDelegate
extension ModifyPostViewController: UITextFieldDelegate {
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


//// MARK: SwiftUI - Preview 추가
//struct ModifyPostViewControllerPreView: PreviewProvider {
//    static var previews: some View {
//        ModifyPostViewController().modifyPostViewControllerToPreview()
//    }
//}
//
//
//#if DEBUG
//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        }
//    }
//
//    func modifyPostViewControllerToPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
