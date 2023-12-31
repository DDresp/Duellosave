//
//  UploadPostDescriptionHeader.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadDescriptionHeader: UIView {
    
    //MARK: - Displayer
    var displayer: UploadDescriptionDisplayer? {
        didSet {
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: STANDARDSPACING, right: 0))
        
    }
    
    //MARK: - Views
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumCustomFont(size: EXTREMESMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.text = "DESCRIPTION"
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumCustomFont(size: EXTREMESMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.textAlignment = .right
        return label
    }()
    
    lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, countLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        return stackView
    }()
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        displayer?.numberOfCharacters.asObservable().subscribe(onNext: { [weak self] (count) in
            self?.countLabel.text = "\(count)/\(self?.displayer?.maxCharacters ?? 0)"
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
