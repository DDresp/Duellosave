//
//  LoginView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import CountryPickerView

class LoginView: UIView {
    
    //MARK: - Displayer
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Child Displayers
    var emailLoginDisplayer: EmailLoginDisplayer {
        return displayer.emailLoginDisplayer
    }
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!

    //MARK: - Setup
    convenience init(parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        self.parentViewController = parentViewController
        self.displayer = displayer
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        setupLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private lazy var textFieldsStackView = LoginTextFieldsStackView(parentViewController: self.parentViewController, displayer: self.displayer)
    private lazy var socialMediaButtonsStackView = LoginButtonsStackView(parentViewController: self.parentViewController, displayer: self.displayer)
    
    private let loginButton: DarkSquaredButton = {
        let button = DarkSquaredButton(type: .system)
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(BLACK, for: .normal)
        button.titleLabel?.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        return button
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "You can also sign in by using facebook, google or your phone number. Click on the corresponding items to do so."
        label.font = UIFont.mediumCustomFont(size: VERYSMALLFONTSIZE)
        label.textColor = GRAY
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        setupLayoutTextFieldsStackView()
        setupLayoutLoginButton()
        setupLayoutForgotPasswordButton()
        setupLayoutHintLabel()
    }
    
    private func setupLayoutTextFieldsStackView() {
        addSubview(textFieldsStackView)
        textFieldsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    private func setupLayoutLoginButton() {
        addSubview(loginButton)
        loginButton.anchor(top: textFieldsStackView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: 0))
    }
    
    private func setupLayoutForgotPasswordButton() {
        addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: loginButton.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 140, height: 30))
    }
    
    private func setupLayoutHintLabel() {
        addSubview(hintLabel)
        if #available(iOS 11, *){
            hintLabel.anchor(top: nil, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 5, right: 10), size: .init(width: 0, height: 40))
        } else {
            hintLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 5, right: 10), size: .init(width: 0, height: 40))
        }
    }
    
    override func layoutSubviews() {
        let numberOfButtons = CGFloat(socialMediaButtonsStackView.numberOfButtons)
        let spacing = socialMediaButtonsStackView.spacing
        let height = (frame.width - (numberOfButtons - 1) * spacing)/numberOfButtons
        addSubview(socialMediaButtonsStackView)
        socialMediaButtonsStackView.anchor(top: nil, leading: leadingAnchor, bottom: hintLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: height))
    }
    
    //MARK: - Methods
    func presentForgotPasswordView() {
        
        var forgotPasswordTextField = UITextField()
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter your email address to reset password.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "email address"
            textField.keyboardType = .emailAddress
            forgotPasswordTextField = textField
        }
        
        let firstAction = UIAlertAction(title: "Cancel", style: .default) { [weak self] (_) in
            self?.displayer.forgotPasswordDismissed.accept(())
            
        }
        let secondAction = UIAlertAction(title: "Submit", style: .default) { [weak self] (_) in
            
            self?.displayer.forgotPasswordDisplayer.email.accept(forgotPasswordTextField.text)
            self?.displayer.forgotPasswordDisplayer.forgotPasswordSubmitTapped.onNext(())
            self?.displayer.forgotPasswordDismissed.accept(())
            
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        parentViewController.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        
        loginButton.rx.tap.asObservable().bind(to: emailLoginDisplayer.loginTapped).disposed(by: disposeBag)
        forgotPasswordButton.rx.tap.asObservable().bind(to: displayer.forgotPasswordTapped).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer.isScrolledUp.asDriver().drive(socialMediaButtonsStackView.rx.isHidden).disposed(by: disposeBag)
        
        displayer.showForgotPasswordView.asObservable().do (onNext: { [weak self] (_) in
            self?.parentViewController.view.endEditing(true)
        }).filter { (showForgotPasswordView) -> Bool in
            return showForgotPasswordView
            }.subscribe { [weak self] (_) in
                self?.presentForgotPasswordView()
            }.disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
