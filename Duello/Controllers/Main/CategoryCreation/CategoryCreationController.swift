//
//  CategoryCreationController.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCreationController: ViewController {
    
    //MARK: - ViewModel
    let viewModel: CategoryCreationViewModel
    
    //MARK: - Setup
    init(viewModel: CategoryCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupLayout()
        setupBindables()
    }
    
    //MARK: - Views
    let createCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Category", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        
        view.addSubview(createCategoryButton)
        createCategoryButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 170, height: 60))
        createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createCategoryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        createCategoryButton.rx.tap.bind(to: viewModel.creationButtonTapped).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
