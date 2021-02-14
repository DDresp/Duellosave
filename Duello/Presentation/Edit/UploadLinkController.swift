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
        view.backgroundColor = BLACK
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    //MARK: - Views
    private let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    private let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.text = "Please provide the link to your Instagram post that you would like to add"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var linkTextField: UITextField = {
        let textField = CustomTextField()
        textField.textColor = WHITE
        textField.autocorrectionType = .no
        textField.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: GRAY, NSAttributedString.Key.font: UIFont.mediumCustomFont(size: SMALLFONTSIZE)])
        textField.backgroundColor = BLACK
        textField.placeholder = "\(displayer.apiDomain) Link"
        return textField
    }()
    
    var progressHud: JGProgressHUD?
    
    //MARK: - Interactions
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
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING))
        
        
        view.addSubview(linkTextField)
        linkTextField.anchor(top: descriptionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: STANDARDSPACING, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))

    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        linkTextField.rx.text.bind(to: displayer.link).disposed(by: disposeBag)
        cancelButton.rx.tap.asDriver().drive(displayer.cancelTapped).disposed(by: disposeBag)
        nextButton.rx.tap.asDriver().drive(displayer.nextTapped).disposed(by: disposeBag)
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
