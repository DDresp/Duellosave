//
//  UploadPostDescriptionHeader.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadPostDescriptionHeader: UIView {
    
    //MARK: - Displayer
    var displayer: UploadPostDescriptionDisplayer? {
        didSet {
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
    }
    
    //MARK: - Views
    let descriptionLabel: SmallHeaderLabel = {
        let label = SmallHeaderLabel()
        label.text = "DESCRIPTION"
        return label
    }()
    
    let countLabel: SmallHeaderLabel = {
        let label = SmallHeaderLabel()
        label.textAlignment = .right
        return label
    }()
    
    lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, countLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
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
