//
//  RegistrationTextFieldsStackView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import TextFieldEffects
import RxSwift

class RegistrationTextFieldsStackView: UIStackView, UITextFieldDelegate {
    
    //MARK: - Displayer
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Child Displayers
    var registrationDisplayer: RegistrationDisplayer {
        return displayer.registrationDisplayer
    }
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!
    
    //MARK: - Setup
    convenience init(parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        distribution = .fillEqually
        spacing = 10
        axis = .vertical
        self.parentViewController = parentViewController
        self.displayer = displayer
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        
        [emailTextField, passwordTextField, confirmPasswordTextField].forEach { (textField) in
            addArrangedSubview(textField)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
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
        textField.borderActiveColor = PURPLE
        return textField
    }()
    
    private let passwordTextField: InteractiveHoshiTextField = {
        let textField = InteractiveHoshiTextField()
        textField.isSecureTextEntry = true
        textField.keyboardType = UIKeyboardType.default
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.placeholder = "Password"
        textField.borderActiveColor = PURPLE
        return textField
    }()
    
    private let confirmPasswordTextField: InteractiveHoshiTextField = {
        let textField = InteractiveHoshiTextField()
        textField.isSecureTextEntry = true
        textField.keyboardType = UIKeyboardType.default
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.placeholder = "Confirm Password"
        textField.borderActiveColor = PURPLE
        return textField
    }()
    
    //MARK: - Delegation
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField as? HoshiTextField, ((textField.text?.count ?? 0) == 0) {
            (textField as? HoshiTextField)?.borderActiveColor = (textField as? HoshiTextField)?.borderActiveColor
        }
    } //otherwise bug that borderInactive Color doesnt show up
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        emailTextField.rx.text.distinctUntilChanged().asObservable().bind(to: registrationDisplayer.email).disposed(by: disposeBag)
        passwordTextField.rx.text.distinctUntilChanged().asObservable().bind(to: registrationDisplayer.password).disposed(by: disposeBag)
        confirmPasswordTextField.rx.text.distinctUntilChanged().asObservable().bind(to: registrationDisplayer.confirmedPassword).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        emailIsValidChanged()
        passwordIsValidChanged()
        confirmedPasswordIsValidChanged()
        clearTextEntries()
    }
    
    private func emailIsValidChanged() {
        registrationDisplayer.emailIsValid.asDriver().map({ (isValid) -> UIColor in
            return isValid ? GREEN : PURPLE
        }).drive(emailTextField.rx.borderActiveColor).disposed(by: disposeBag)
    }
    
    private func passwordIsValidChanged() {
        registrationDisplayer.passwordIsValid.asDriver().map({ (isValid) -> UIColor in
            return isValid ? GREEN : PURPLE
        }).drive(passwordTextField.rx.borderActiveColor).disposed(by: disposeBag)
    }
    
    private func confirmedPasswordIsValidChanged() {
        registrationDisplayer.confirmedPasswordIsValid.asObservable().map { (isValid) -> UIColor in
            return isValid ? GREEN : PURPLE
            }.subscribe (onNext: { [weak self] (color) in
                if (self?.confirmPasswordTextField.text?.count ?? 0) == 0 { return } //otherwise the textField will appear to be selected after clearing text entries
                
                self?.confirmPasswordTextField.borderActiveColor = color
                if self?.confirmPasswordTextField.isEditing ?? false {
                    self?.confirmPasswordTextField.animateViewsForTextEntry()
                    return
                }
                if let confirmedPasswordCharacters = self?.registrationDisplayer.confirmedPassword.value, confirmedPasswordCharacters.count > 0 {
                    self?.confirmPasswordTextField.animateViewsForTextEntry()
                    return
                }
            }).disposed(by: disposeBag)
    }
    
    private func clearTextEntries() {
        registrationDisplayer.clearTextEntries.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.emailTextField.text = nil
            self?.passwordTextField.text = nil
            self?.confirmPasswordTextField.text = nil
            
            //Rx doesnt seem to be triggered when text of textField is set programmatically, so update viewModel here
            self?.registrationDisplayer.email.accept(nil)
            self?.registrationDisplayer.password.accept(nil)
            self?.registrationDisplayer.confirmedPassword.accept(nil)
            
            //otherwise bug that borderInactive Color doesnt show up
            self?.emailTextField.borderActiveColor = PURPLE
            self?.passwordTextField.borderActiveColor = PURPLE
            self?.confirmPasswordTextField.borderActiveColor = PURPLE
        }).disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
