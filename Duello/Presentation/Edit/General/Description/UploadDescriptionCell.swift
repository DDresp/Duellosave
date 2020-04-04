//
//  UploadPostDescriptionCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class UploadDescriptionCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadDescriptionDisplayer? {
        didSet {
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleLabel))
        placeholderLabel.addGestureRecognizer(tapgesture)
        
    }
    
    //MARK: - Views
    let placeholderLabel: InputLabel = {
        let label = InputLabel()
        label.text = "Add a description for your post"
        label.textColor = PLACEHOLDERCOLOR
        label.isUserInteractionEnabled = true
        label.backgroundColor = .clear
        return label
    }()
    
    let textView: InputTextView = {
        let textView = InputTextView()
        textView.isScrollEnabled = false
        return textView
    }()
    
    //MARK: - Interactions
    @objc func handleLabel() {
        textView.becomeFirstResponder()
    }
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(textView)
        textView.fillSuperview()
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.fillSuperview()
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        
        textView.rx.text.bind(to: displayer.rawDescription).disposed(by: disposeBag)
        textView.rx.didBeginEditing.bind(to: displayer.didBeginEditing).disposed(by: disposeBag)
        textView.rx.didEndEditing.bind(to: displayer.didEndEditing).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        
        displayer.description.asObservable().subscribe(onNext: { [weak self] (text) in
            self?.textView.text = text
        }).disposed(by: disposeBag)
        
        displayer.showPlaceHolderLabel.asObservable().bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
