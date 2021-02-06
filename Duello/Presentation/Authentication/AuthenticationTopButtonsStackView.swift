//
//  AuthenticationTopButtonsStackView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class AuthenticationTopButtonsStackView: UIStackView {
    
    //MARK: - Displayer
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!

    //MARK: - Setup
    convenience init(parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        self.parentViewController = parentViewController
        self.displayer = displayer
        setupLayout()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.mediumCustomFont(size: LARGEFONTSIZE)
        button.setTitleColor(BLACK, for: .normal)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.mediumCustomFont(size: LARGEFONTSIZE)
        button.setTitleColor(GRAY, for: .normal)
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        addArrangedSubview(signInButton)
        addArrangedSubview(signUpButton)
        distribution = .fillEqually
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        
        signUpButton.rx.tap.asObservable().bind(to: displayer.signUpTapped).disposed(by: disposeBag)
        signInButton.rx.tap.asObservable().bind(to: displayer.signInTapped).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer.showRegistrationView.asDriver().map { (isHidden) -> UIColor in
            return isHidden ? GRAY : BLACK
            }.drive(signInButton.rx.titleColor).disposed(by: disposeBag)
        
        displayer.showLoginView.asDriver().map { (isHidden) -> UIColor in
            return isHidden ? GRAY : BLACK
            }.drive(signUpButton.rx.titleColor).disposed(by: disposeBag)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
