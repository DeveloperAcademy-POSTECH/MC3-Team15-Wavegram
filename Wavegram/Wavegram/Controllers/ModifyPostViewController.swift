//
//  ModifyPostViewController.swift
//  Wavegram
//
//  Created by 김상현 on 2022/07/18.
//

import UIKit

class ModifyPostViewController: UIViewController {
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
        imageView.image = UIImage(named: "testImage1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제목 *"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
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
        label.text = "메모"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [representativeImageLabel, representativeImage, titleLabel, titleTextField, memoLabel, memoTextField].forEach {self.view.addSubview($0)}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [self] in
            self.view.backgroundColor = .black
            self.setConstraints()
            self.setTitleTextFieldBorder()
            titleTextField.setClearButton(with: UIImage(systemName: "x.circle")!, mode: .always)
            memoTextField.setClearButton(with: UIImage(systemName: "x.circle")!, mode: .always)
        }
    }
    
    private func setTitleTextFieldBorder() {
        self.titleTextField.layer.addBorder([.bottom], color: .white, width: 1)
        self.memoTextField.layer.addBorder([.bottom], color: .white, width: 1)
    }
    
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
        
        [representativeImageLabelConstraints, representativeImageConstraints, titleLabelConstraints, titleTextFieldConstraints, memoLabelConstraints, memoTextFieldConstraints].forEach {NSLayoutConstraint.activate($0)}
    }
}
