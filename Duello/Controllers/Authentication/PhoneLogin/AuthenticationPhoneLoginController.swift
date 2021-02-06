//
//  AuthenticationPhoneLoginController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import JGProgressHUD

class AuthenticationPhoneLoginController: ViewController {
    
    //MARK: - ViewModel
    var viewModel: PhoneLoginViewModel
    
    //MARK: - Setup
    init(viewModel: PhoneLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        setupBindablesToViewModel()
        setupBindablesFromViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LIGHT_GRAY
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    //MARK: - Views
    private lazy var phoneNumberView = PhoneNumberView(displayer: self.viewModel)
    private var progressHud: JGProgressHUD?
    
    private let phoneSubmitButton: DarkSquaredButton = {
        let button = DarkSquaredButton(type: .system)
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    //MARK: - Interactions
    @objc private func handleCancel() {
        viewModel.cancelTapped.onNext(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        phoneNumberView.phoneNumberTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    //MARK: - Layout
    private func setupLayout() {
        
        view.addSubview(phoneNumberView)
        phoneNumberView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        view.addSubview(phoneSubmitButton)
        phoneSubmitButton.anchor(top: phoneNumberView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: STANDARDSPACING))
    }
    
    //MARK: - Methods
    func presentPhoneNumberVerificationView() {
        var verificationCodeTextField = UITextField()
        
        let alert = UIAlertController(title: "Verify Phone Number", message: "Please enter the code sent to your phone number to verify your account.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "verification code"
            textField.font = UIFont.mediumCustomFont(size: MEDIUMFONTSIZE - 1)
            textField.textColor = DARK_GRAY
            textField.keyboardType = .phonePad
            verificationCodeTextField = textField
        }
        let firstAction = UIAlertAction(title: "Cancel", style: .default)
        let secondAction = UIAlertAction(title: "Submit", style: .default) { [weak self] (textField) in
            
            self?.viewModel.verificationCode.accept(verificationCodeTextField.text)
            self?.viewModel.verificationCodeSubmitTapped.onNext(())
            
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        phoneSubmitButton.rx.tap.asObservable().bind(to: viewModel.phoneNumberSubmitTapped).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromViewModel() {
        
        viewModel.alert.asObservable().subscribe(onNext: { [weak self] (alert) in
            let alertController = UIAlertController(title: alert?.alertHeader ?? "", message: alert?.alertMessage ?? "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable().subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                let progressHud = JGProgressHUD(style: .dark)
                progressHud.textLabel.text = self.viewModel.progressHudMessage
                self.progressHud = progressHud
                self.progressHud?.show(in: self.view)
            } else {
                self.progressHud?.dismiss()
            }
        }).disposed(by: disposeBag)
        
        viewModel.showPhoneNumberVerificationView.asObservable().subscribe(onNext: { [weak self] (showPhoneNumberVerificationView) in
            self?.presentPhoneNumberVerificationView()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
