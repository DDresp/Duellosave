//
//  AuthenticationController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import JGProgressHUD
import RxSwift
import GoogleSignIn
import CountryPickerView
import Firebase

class AuthenticationController: ViewController {
    
    //MARK: - ViewModel
    var viewModel: AuthenticationViewModel
    
    //MARK: - Setup
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboard() //to hide the keyboard when user taps outside the textfields
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupLayout()
        setupBindablesFromViewModel()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return viewModel.isScrolledUp.value
    }
    
    //MARK: - Views
    private lazy var loginAndRegistrationView = AuthenticationView(size: view.frame.size, parentViewController: self, displayer: self.viewModel)
    private let scrollView = UIScrollView()
    private var progressHud: JGProgressHUD?
    
    //MARK: - Interactions
    @objc func keyboardWillShow(notification:NSNotification){
        viewModel.keyboardWillShow()
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        viewModel.keyboardWillHide()
    }
    
    //MARK: - Layout
    private func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(loginAndRegistrationView)
        loginAndRegistrationView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(), size: CGSize(width: view.frame.width, height: view.frame.height))
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromViewModel() {
        
        viewModel.clearTextEntries.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        viewModel.alert.asObservable().subscribe(onNext: { [weak self] (alert) in
            guard let alert = alert else { return }
            self?.presentOneButtonAlert(header: alert.alertHeader, message: alert.alertMessage, buttonTitle: "OK", action: nil)
        }).disposed(by: disposeBag)
        
        viewModel.isScrolledUp.asObservable().subscribe(onNext: { [weak self] (isScrolledUp) in
            if isScrolledUp {
                
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: self?.loginAndRegistrationView.headerHeight ?? 0), animated: true)
            } else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                     self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                })
               
            }
            self?.setNeedsStatusBarAppearanceUpdate()
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
