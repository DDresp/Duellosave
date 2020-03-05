//
//  UploadLinkController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import JGProgressHUD

class UploadLinkViewController: ViewController {
    
    //MARK: - Displayer
    var displayer: UploadLinkDisplayer
    
    //MARK: - Setup
    init(displayer: UploadLinkDisplayer) {
        self.displayer = displayer
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = EXTREMELIGHTGRAYCOLOR
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    //MARK: - Views
    lazy var linkTextField: InputTextField = {
        let textField = InputTextField()
        textField.placeholder = "\(displayer.apiDomain) Link"
        return textField
    }()
    
    let submitButton: DarkSquaredButton = {
        let button = DarkSquaredButton(type: .system)
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    var progressHud: JGProgressHUD?
    
    //MARK: - Interactions
    @objc private func handleCancel() {
        displayer.cancelTapped.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        linkTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    //MARK: - Layout
    private func setupLayout() {
        view.addSubview(linkTextField)
        linkTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        view.addSubview(submitButton)
        submitButton.anchor(top: linkTextField.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: STANDARDSPACING))
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        linkTextField.rx.text.bind(to: displayer.link).disposed(by: disposeBag)
        submitButton.rx.tap.bind(to: displayer.submitTapped).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer.alert.subscribe(onNext: { [weak self] (alert) in
            let alertController = UIAlertController(title: alert.alertHeader ?? "", message: alert.alertMessage ?? "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        displayer.isLoading.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                let progressHud = JGProgressHUD(style: .dark)
                progressHud.textLabel.text = self.displayer.progressHudMessage
                self.progressHud = progressHud
                self.progressHud?.show(in: self.view.window ?? self.view)
            } else {
                self.progressHud?.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
