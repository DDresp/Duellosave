//
//  CategoryProfileController.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryProfileController: ViewController {
    
    //MARK: - ViewModels
    let viewModel: ExploreCategoryProfileViewModel
    
    //MARK: - Setup
    init(viewModel: ExploreCategoryProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VERYLIGHTGRAYCOLOR
        setupNavigationItems()
        setupLayout()
        setupBindablesToViewModel()
    }
    
    private func setupNavigationItems() {
        navigationController?.navigationBar.tintColor = DARKGRAYCOLOR
    }
    
    //MARK: - Views
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("add content", for: .normal)
        button.backgroundColor = DARKGRAYCOLOR
        button.setTitleColor(VERYLIGHTGRAYCOLOR, for: .normal)
        return button
    }()
    
    
    //MARK: - Layout
    private func setupLayout() {
        view.addSubview(addButton)
        addButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 100))
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        
        addButton.rx.tap.map { (_) -> Void in
            return ()
            }.bind(to: viewModel.requestedAddContent).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
