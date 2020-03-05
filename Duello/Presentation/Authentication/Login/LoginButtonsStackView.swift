//
//  LoginButtonsStackView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleSignIn

class LoginButtonsStackView: UIStackView {
    
    //MARK: - Displayers
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!

    //MARK: - Setup
    convenience init(parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        self.parentViewController = parentViewController
        self.displayer = displayer
        axis = .horizontal
        distribution = .fillEqually
        spacing = 45
        setupBindablesToDisplayer()
        
        [facebookButton, googleButton, phoneButton].forEach { (button) in
            addArrangedSubview(button)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private lazy var buttons = [facebookButton, googleButton, phoneButton]
    
    private lazy var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "phone").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    //MARK: - Getters
    var numberOfButtons: Int {
        return buttons.count
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        facebookButton.rx.tap.asObservable().bind(to: displayer.facebookTapped).disposed(by: disposeBag)
        googleButton.rx.tap.asObservable().bind(to: displayer.googleTapped).disposed(by: disposeBag)
        phoneButton.rx.tap.asObservable().bind(to: displayer.phoneTapped).disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
