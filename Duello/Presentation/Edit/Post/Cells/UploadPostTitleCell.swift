//
//  UploadPostTitleCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadPostTitleCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadPostTitleDisplayer? {
        didSet {
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Variables
    var previousTitle = ""
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
    }
    
    //MARK: - Views
    lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, emptyView])
        stackView.axis = .vertical
        return stackView
    }()
    
    let textField: InputTextField = {
        let textField = InputTextField()
        textField.placeholder = "Add a title for your post (required)"
        return textField
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = EXTREMELIGHTGRAYCOLOR
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return view
    }()
    
    //MARK: - Methods
    var textTooLong: Bool {
        let startWidth = textField.frame.size.width
        let calcWidth = textField.sizeThatFits(textField.frame.size).width
        return calcWidth > startWidth
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        
        textField.rx.text.map { [weak self] (text) -> (String?) in
            guard let self = self else { return nil }
            guard let text = text else { return nil }
            
            //title shouldnt be longer than the width of the label
            let startWidth = self.textField.frame.size.width
            let calcWidth = self.textField.sizeThatFits(self.textField.frame.size).width + STANDARDSPACING
            let tooLong = calcWidth > startWidth
            
            if self.previousTitle.count > text.count {
                self.previousTitle = text
                return text
            }
            
            if tooLong == true {
                return self.previousTitle
            } else {
                self.previousTitle = text
                return text
            }
            
            }.bind(to: displayer.title).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromDisplayer() {
        displayer?.title.asObservable().subscribe(onNext: { [weak self] (text) in
            self?.textField.text = text
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
