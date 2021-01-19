//
//  UploadUserTableViewCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa


class UploadUserTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    //MARK: - Displayer
    var displayer: EditUserItemDisplayer? {
        didSet {
            setupLayout()
            setupBindables()
        }
    }
    
    //MARK: - Variables
    private let nameTextFieldTag = 0
    private let linkTextFieldTag = 1
    
    
    //MARK: - Views
    
    //NAME
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = STANDARDSPACING
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let iv = CustomImageView(width: 30, height: 30)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var nameTextField: UITextField = {
        let textField = CustomTexField(width: 1000, height: 38)
        textField.tag = nameTextFieldTag
        textField.textColor = WHITE
        textField.autocorrectionType = .no
        textField.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: GRAY])
        textField.backgroundColor = BLACK
        return textField
    }()

    //LINK
    private let linkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = STANDARDSPACING
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        return stackView
    }()
    
    private let emptyView: UIView = {
        let view = CustomView(width: 30, height: 30)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var linkTextField: UITextField = {
        let textField = CustomTexField(width: 1000, height: 38)
        textField.tag = linkTextFieldTag
        textField.textColor = WHITE
        textField.autocorrectionType = .no
        textField.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: GRAY])
        textField.backgroundColor = BLACK
        textField.delegate = self
        return textField
    }()
    
    //OVERALL
    private let overallStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = BLACK
        contentView.addSubview(overallStackView)
        overallStackView.fillSuperview()

        
    }
    
    //MARK: - Layout
    private func setupLayout() {
        guard let displayer = displayer else { return }
        
        setupNameView()
        
        if displayer.userCanAddLink {
            setupLinkView()
        }

    }
    
    private func setupNameView() {
        
        guard let displayer = displayer else { return }
        
        setupNameTextField()
        if displayer.hasIcon {
            setupIconImageView()
            nameStackView.addArrangedSubview(iconImageView)
        }
        nameStackView.addArrangedSubview(nameTextField)
        overallStackView.addArrangedSubview(nameStackView)
    }
    
    private func setupNameTextField() {
        guard let displayer = displayer else { return }
        nameTextField.placeholder = displayer.namePlaceholderString
        nameTextField.text = displayer.name.value
//        nameTextField.textColor = displayer.hasDefaultLink ? WHITE : GRAY
    }
    
    private func setupIconImageView() {
        guard let displayer = displayer else { return }
        guard let iconImageName = displayer.iconName else { return }
        iconImageView.image = UIImage(named: iconImageName)
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupLinkView() {
        guard let displayer = displayer else { return }

        setupLinkTextField()
        if displayer.hasIcon {
            setupEmptyView()
            linkStackView.addArrangedSubview(emptyView)
        }
        linkStackView.addArrangedSubview(linkTextField)
        overallStackView.addArrangedSubview(linkStackView)
    }
    
    private func setupLinkTextField() {
        guard let displayer = displayer else { return }
//        linkTextField = InputTextField()
        linkTextField.text = displayer.link?.value ?? ""
//        linkTextField!.tag = linkTextFieldTag
//        linkTextField!.delegate = self
//        linkTextField!.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        linkTextField!.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupEmptyView() {
        emptyView.setContentHuggingPriority(.required, for: .horizontal)
        emptyView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    //MARK: - Delegation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == nameTextFieldTag {
            return true
        }
        
        guard let linkPrefix = displayer?.linkPrefix else { return true }
        guard let text = textField.text else { return true }
        
        if linkPrefix.count >= (text.count + string.count) {
            return false
        }
        if range.lowerBound < linkPrefix.count {
            return false
        }
        return true
    }

    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindables() {
        guard let displayer = displayer else { return }
        
        setupNameBindables()
        if displayer.userCanAddLink {
            setupLinkBindables()
        }
        
    }
    
    private func setupNameBindables() {
        guard let displayer = displayer else { return }
        
        nameTextField.rx.text.distinctUntilChanged().bind(to: displayer.name).disposed(by: disposeBag)
        
        displayer.nameIsEdited.map({ (isEdited) -> CGFloat in
            return isEdited ? 1 : LIGHTALPHA
        }).bind(to: iconImageView.rx.alpha).disposed(by: disposeBag)
        
    }
    
    private func setupLinkBindables() {
        guard let displayer = displayer else { return }

//        guard let linkTextField = linkTextField else { return }
        guard let displayerLink = displayer.link else { return }
        linkTextField.rx.text.distinctUntilChanged().bind(to: displayerLink).disposed(by: disposeBag)

        guard let displayerLinkIsEdited = displayer.linkIsEdited else { return }
        displayerLinkIsEdited.map({ (isEdited) -> UIColor in
            return isEdited ? WHITE : GRAY
        }).subscribe(onNext: { [weak self] (color) in
//            self?.nameTextField.textColor = color
            self?.linkTextField.textColor = color
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//import RxSwift
//import RxCocoa
//
//class UploadUserTableViewCell: UITableViewCell, UITextFieldDelegate {
//
//    //MARK: - Displayer
//    var displayer: EditUserItemDisplayer? {
//        didSet {
//            setupLayout()
//            setupBindables()
//        }
//    }
//
//    //MARK: - Variables
//    private let nameTextFieldTag = 0
//    private let linkTextFieldTag = 1
//
//    //MARK: - Views
//    private let nameStackView = SquashedHorizontalStackView()
//    private let linkStackView = SquashedHorizontalStackView()
//
//    private let iconImageViewContainer = LargeIconImageViewContainer()
//    private let emptyImageViewContainer = LargeIconImageViewContainer()
//
//    private let iconImageView: LargeIconImageView = {
//        let imageView = LargeIconImageView(frame: .zero)
//        return imageView
//    }()
//
//    private let overallStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.distribution = .fillEqually
//        stackView.axis = .vertical
//        stackView.spacing = 5
//        return stackView
//    }()
//
//    private lazy var nameTextField: InputTextField = {
//        let textField = InputTextField()
//        textField.tag = nameTextFieldTag
//        return textField
//    }()
//
//    private var linkTextField: InputTextField?
//
//    //MARK: - Setup
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = BLACK
//        addSubview(overallStackView)
//        overallStackView.fillSuperview()
//
//    }
//
//    //MARK: - Layout
//    private func setupLayout() {
//        guard let displayer = displayer else { return }
//
//        setupNameView()
//
//        if displayer.userCanAddLink {
//            setupLinkView()
//        }
//
//    }
//
//    private func setupNameView() {
//
//        guard let displayer = displayer else { return }
//
//        setupNameTextField()
//        if displayer.hasIcon {
//            setupIconImageView()
//            nameStackView.addArrangedSubview(iconImageViewContainer)
//        }
//        nameStackView.addArrangedSubview(nameTextField)
//        overallStackView.addArrangedSubview(nameStackView)
//    }
//
//    private func setupNameTextField() {
//        guard let displayer = displayer else { return }
//        nameTextField.placeholder = displayer.namePlaceholderString
//        nameTextField.text = displayer.name.value
//        nameTextField.textColor = displayer.hasDefaultLink ? WHITE : GRAY
//        nameTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        nameTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//    }
//
//    private func setupIconImageView() {
//
//        guard let displayer = displayer else { return }
//        guard let iconImageName = displayer.iconName else { return }
////        iconImageView.image = UIImage(named: iconImageName)?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: 0, bottom: -5, right: 0))
////        iconImageView.image = UIImage(named: iconImageName)
//        iconImageView.backgroundColor = .red
//
//        iconImageViewContainer.setContentHuggingPriority(.required, for: .horizontal)
//        iconImageViewContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
//        iconImageViewContainer.addSubview(iconImageView)
//        iconImageView.anchor(top: iconImageViewContainer.topAnchor, leading: iconImageViewContainer.leadingAnchor, bottom: iconImageViewContainer.bottomAnchor, trailing: iconImageViewContainer.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING + 5, bottom: 0, right: 0))
//
//    }
//
//    private func setupLinkView() {
//        guard let displayer = displayer else { return }
//
//        setupLinkTextField()
//        if displayer.hasIcon {
//            setupEmptyImageContainer()
//            linkStackView.addArrangedSubview(emptyImageViewContainer)
//        }
//        linkStackView.addArrangedSubview(linkTextField!)
//        overallStackView.addArrangedSubview(linkStackView)
//    }
//
//    private func setupLinkTextField() {
//        guard let displayer = displayer else { return }
//        linkTextField = InputTextField()
//        linkTextField!.text = displayer.link?.value ?? ""
//        linkTextField!.tag = linkTextFieldTag
//        linkTextField!.delegate = self
//        linkTextField!.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        linkTextField!.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//    }
//
//    private func setupEmptyImageContainer() {
//        emptyImageViewContainer.setContentHuggingPriority(.required, for: .horizontal)
//        emptyImageViewContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
//    }
//
//    //MARK: - Delegation
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField.tag == nameTextFieldTag {
//            return true
//        }
//
//        guard let linkPrefix = displayer?.linkPrefix else { return true }
//        guard let text = textField.text else { return true }
//
//        if linkPrefix.count >= (text.count + string.count) {
//            return false
//        }
//        if range.lowerBound < linkPrefix.count {
//            return false
//        }
//        return true
//    }
//
//    //MARK: - Reactive
//    private var disposeBag = DisposeBag()
//
//    private func setupBindables() {
//        guard let displayer = displayer else { return }
//
//        setupNameBindables()
//        if displayer.userCanAddLink {
//            setupLinkBindables()
//        }
//
//    }
//
//    private func setupNameBindables() {
//        guard let displayer = displayer else { return }
//
//        nameTextField.rx.text.asObservable().distinctUntilChanged().bind(to: displayer.name).disposed(by: disposeBag)
//
//        displayer.nameIsEdited.asObservable().map({ (isEdited) -> CGFloat in
//            return isEdited ? 1 : LIGHTALPHA
//        }).bind(to: iconImageView.rx.alpha).disposed(by: disposeBag)
//
//    }
//
//    private func setupLinkBindables() {
//
//        guard let displayer = displayer else { return }
//
//        guard let linkTextField = linkTextField else { return }
//        guard let displayerLink = displayer.link else { return }
//        linkTextField.rx.text.asObservable().distinctUntilChanged().do(onNext: { (link) in
//        }).bind(to: displayerLink).disposed(by: disposeBag)
//
//        guard let displayerLinkIsEdited = displayer.linkIsEdited else { return }
//        displayerLinkIsEdited.asObservable().map({ (isEdited) -> UIColor in
//            return isEdited ? WHITE : GRAY
//        }).subscribe(onNext: { [weak self] (color) in
//            self?.nameTextField.textColor = color
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
