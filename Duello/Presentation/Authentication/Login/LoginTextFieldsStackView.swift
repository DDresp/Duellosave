//
//  LoginTextFieldsStackView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import TextFieldEffects
import RxSwift

class LoginTextFieldsStackView: UIStackView, UITextFieldDelegate {
    
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
        distribution = .fillEqually
        spacing = 10
        axis = .vertical
        setupBindablesFromDisplayer()
        setupBindablesToDisplayer()
        
        [emailTextField, passwordTextField].forEach { (textField) in
            addArrangedSubview(textField)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private let emailTextField: InteractiveHoshiTextField = {
        let textField = InteractiveHoshiTextField()
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.placeholder = "Email"
        return textField
    }()
    
    private let passwordTextField: InteractiveHoshiTextField = {
        let textField = InteractiveHoshiTextField()
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.placeholder = "Password"
        return textField
    }()
    
    //MARK: - Delegation
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        emailLoginDisplayer.clearTextEntries.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.emailTextField.text = ""
            self?.passwordTextField.text = ""
        }).disposed(by: disposeBag)
    }
    
    private func setupBindablesToDisplayer() {
        
        emailTextField.rx.text.asObservable().distinctUntilChanged().bind(to: emailLoginDisplayer.email).disposed(by: disposeBag)
        passwordTextField.rx.text.asObservable().distinctUntilChanged().bind(to: emailLoginDisplayer.password).disposed(by: disposeBag)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
