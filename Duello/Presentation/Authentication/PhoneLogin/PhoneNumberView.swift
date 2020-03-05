//
//  PhoneNumberView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import CountryPickerView
import RxSwift
import RxCocoa

class PhoneNumberView: UIView, CountryPickerViewDelegate, CountryPickerViewDataSource, UITextFieldDelegate {
    
    //MARK: - Displayer
    private var displayer: PhoneLoginDisplayer!
    
    //MARK: - Setup
    convenience init(displayer: PhoneLoginDisplayer) {
        self.init()
        self.displayer = displayer
        cpv.delegate = self
        cpv.dataSource = self
        cpv.showPhoneCodeInView = false
        cpv.showCountryCodeInView = false
        backgroundColor = .white
        phoneCodeLabel.text = cpv.selectedCountry.phoneCode
        setupLayout()
        setupBindablesToDisplayer()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private let cpv = CountryPickerView()
    
    private let phoneCodeLabel: StaticTextField = {
        let label = StaticTextField()
        return label
    }()
    
    let phoneNumberTextField: NumberTextField = {
        let textField = NumberTextField()
        textField.placeholder = "Phone Number"
        return textField
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(phoneCodeLabel)
        addSubview(phoneNumberTextField)
        addSubview(cpv)
        
        cpv.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        phoneCodeLabel.anchor(top: topAnchor, leading: cpv.trailingAnchor, bottom: bottomAnchor, trailing: nil)
        phoneNumberTextField.anchor(top: topAnchor, leading: phoneCodeLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        phoneCodeLabel.setContentHuggingPriority(phoneNumberTextField.contentHuggingPriority(for: .horizontal) + 1, for: .horizontal)
        phoneCodeLabel.setContentCompressionResistancePriority(phoneNumberTextField.contentCompressionResistancePriority(for: .horizontal) + 1, for: .horizontal)
    }
    
    //MARK: - Delegation
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        phoneCodeLabel.text = country.phoneCode
        phoneCodeLabel.sendActions(for: .valueChanged) //Rxswift doesnt bind the textField.text to the viewModel, if the text changed programmatically. Therefor we need to implement "sendActions" here.
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        
        phoneCodeLabel.rx.text.asObservable().bind(to: displayer.countryCode).disposed(by: disposeBag)
        phoneNumberTextField.rx.text.asObservable().distinctUntilChanged().bind(to: displayer.phoneNumberWithoutCountryCode).disposed(by: disposeBag)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
