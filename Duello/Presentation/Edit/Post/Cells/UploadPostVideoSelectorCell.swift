//
//  UploadPostTypeSelectorCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadPostVideoSelectorCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadPostTypeSelectorDisplayer? {
        didSet {
            setupBindablesToDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupLayout()
    }
    
    //MARK: - Views
    private var videoLabel: UILabel = {
        let label = UILabel()
        label.text = "Videos"
        label.textColor = DARKGRAYCOLOR
        label.font = UIFont.mediumCustomFont(size: MEDIUMFONTSIZE)
        return label
    }()
    
    private var videoSwitch: UISwitch = {
        let videoSwitch = UISwitch()
        videoSwitch.isOn = false
        return videoSwitch
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(videoLabel)
        contentView.addSubview(videoSwitch)
        videoLabel.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        videoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        videoSwitch.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: STANDARDSPACING), size: .init(width: 60, height: 30))
        videoSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        videoSwitch.rx.isOn.asDriver().drive(displayer.videoIsOn).disposed(by: disposeBag)
    }
}



//class UploadPostTypeSelectorCell: UITableViewCell {
//
//    //MARK: - Displayer
//    var displayer: UploadPostTypeSelectorDisplayer? {
//        didSet {
//            setupBindablesToDisplayer()
//            setupBindablesFromDisplayer()
//        }
//    }
//
//    //MARK: - Variables
//    var previousTitle = ""
//
//    //MARK: - Setup
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(overallStackView)
//        overallStackView.fillSuperview()
//
//    }
//
//    //MARK: - Views
//    lazy var overallStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [textField, emptyView])
//        stackView.axis = .vertical
//        return stackView
//    }()
//
//    let textField: InputTextField = {
//        let textField = InputTextField()
//        textField.placeholder = "Add a title for your post (required)"
//        return textField
//    }()
//
//    let emptyView: UIView = {
//        let view = UIView()
//        view.backgroundColor = EXTREMELIGHTGRAYCOLOR
//        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
//        return view
//    }()
//
//    //MARK: - Methods
//    var textTooLong: Bool {
//        let startWidth = textField.frame.size.width
//        let calcWidth = textField.sizeThatFits(textField.frame.size).width
//        return calcWidth > startWidth
//    }
//
//    //MARK: - Reactive
//    private var disposeBag = DisposeBag()
//
//    private func setupBindablesToDisplayer() {
//        guard let displayer = displayer else { return }
//
//        textField.rx.text.map { [weak self] (text) -> (String?) in
//            guard let self = self else { return nil }
//            guard let text = text else { return nil }
//
//            //title shouldnt be longer than the width of the label
//            let startWidth = self.textField.frame.size.width
//            let calcWidth = self.textField.sizeThatFits(self.textField.frame.size).width + STANDARDSPACING
//            let tooLong = calcWidth > startWidth
//
//            if self.previousTitle.count > text.count {
//                self.previousTitle = text
//                return text
//            }
//
//            if tooLong == true {
//                return self.previousTitle
//            } else {
//                self.previousTitle = text
//                return text
//            }
//
//            }.bind(to: displayer.title).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesFromDisplayer() {
//        displayer?.title.asObservable().subscribe(onNext: { [weak self] (text) in
//            self?.textField.text = text
//        }).disposed(by: disposeBag)
//    }
//
//    override func prepareForReuse() {
//        disposeBag = DisposeBag()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
