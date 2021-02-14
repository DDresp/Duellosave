//
//  RegistrationView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import TextFieldEffects
import RxSwift

class RegistrationView: UIView {
    
    //MARK: - Displayers
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
        self.parentViewController = parentViewController
        self.displayer = displayer
        setupBindablesToDisplayer()
        setupLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private lazy var textFieldsStackView = RegistrationTextFieldsStackView(parentViewController: self.parentViewController, displayer: self.displayer)
    
    private lazy var registerButton: CustomButton = {
        let button = CustomButton(style: .dark, width: nil, height: nil)
        button.setTitle("Register", for: .normal)
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        setupLayoutTextFieldsStackView()
        setupLayoutRegisterButton()
    }
    
    private func setupLayoutTextFieldsStackView() {
        addSubview(textFieldsStackView)
        textFieldsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    private func setupLayoutRegisterButton() {
        addSubview(registerButton)
        registerButton.anchor(top: textFieldsStackView.bottomAnchor, leading: nil, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        registerButton.rx.tap.asObservable().bind(to: registrationDisplayer.registrationTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
