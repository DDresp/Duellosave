//
//  AuthenticationView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class AuthenticationView: UIView {
    
    //MARK: - Displayer
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!
    private var size: CGSize?
    
    //MARK: - Setup
    convenience init(size: CGSize, parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        backgroundColor = .white
        self.size = size
        self.parentViewController = parentViewController
        self.displayer = displayer
        setupLayout()
        setupBindablesFromDisplayer()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private lazy var headerView = AuthenticationHeader(parentViewController: self.parentViewController, displayer: self.displayer)
    private lazy var topButtonsStackView = AuthenticationTopButtonsStackView(parentViewController: self.parentViewController, displayer: self.displayer)
    private lazy var loginView = LoginView(parentViewController: self.parentViewController, displayer: self.displayer)
    private lazy var registrationView = RegistrationView(parentViewController: self.parentViewController, displayer: self.displayer)
    
    //MARK: - Layout
    private func setupLayout() {
        setupLayoutHeaderView()
        setupLayoutTopBottomsStackView()
        setupLayoutLoginView()
        setupLayoutRegistrationView()
    }
    
    private func setupLayoutHeaderView() {
        addSubview(headerView)
        headerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: headerWidth, height: headerHeight))
    }
    private func setupLayoutTopBottomsStackView() {
        addSubview(topButtonsStackView)
        topButtonsStackView.anchor(top: headerView.bottomAnchor, leading: headerView.leadingAnchor, bottom: nil, trailing: headerView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 65))
    }
    
    private func setupLayoutLoginView() {
        addSubview(loginView)
        loginView.anchor(top: topButtonsStackView.bottomAnchor, leading: headerView.leadingAnchor, bottom: bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING), size: .init(width: 0, height: 0))
    }
    
    private func setupLayoutRegistrationView() {
        addSubview(registrationView)
        registrationView.anchor(top: topButtonsStackView.bottomAnchor, leading: headerView.leadingAnchor, bottom: bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING), size: .init(width: 0, height: 0))
    }
    
    //MARK: - Getters
    var headerHeight: CGFloat {
        return (size?.height ?? 0) / 4
    }
    var headerWidth: CGFloat {
        return size?.width ?? 0
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        displayer.showLoginView.asDriver().do (onNext: { [weak self] (_) in
            self?.parentViewController.view.endEditing(true)
        }).map { (showLoginView) -> Bool in
            return !showLoginView
            }.drive(loginView.rx.isHidden).disposed(by: disposeBag)
        
        displayer.showRegistrationView.asDriver().do (onNext: { [weak self] (_) in
            self?.parentViewController.view.endEditing(true)
        }).map { (showRegistrationView) -> Bool in
            return !showRegistrationView
            }.drive(registrationView.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
