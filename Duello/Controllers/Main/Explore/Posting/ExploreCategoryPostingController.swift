//
//  PostingController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import YPImagePicker
import AVFoundation
import RxSwift
import RxCocoa

class ExploreCategoryPostingController: ViewController {
    
    //MARK: - ViewModel
    let viewModel: ExploreCategoryPostingViewModel
    
    //MARK: - Setup
    init(viewModel: ExploreCategoryPostingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DARK_GRAY
        setupLayout()
        setupBindablesToViewModel()
    }
    
    //MARK: - Views
    let uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("upload Image", for: .normal)
        button.setTitleColor(BLACK, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        return button
    }()
    
    let uploadVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("upload Video", for: .normal)
        button.setTitleColor(BLACK, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        return button
    }()
    
    let uploadInstagramVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("upload instagram video", for: .normal)
        button.setTitleColor(BLACK, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        return button
    }()
    
    let uploadInstagramImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("upload instagram image", for: .normal)
        button.setTitleColor(BLACK, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        let horizontalStackView = UIStackView(arrangedSubviews: [uploadImageButton, uploadVideoButton])
        horizontalStackView.spacing = 20
        let secondHorizontalStackView = UIStackView(arrangedSubviews: [uploadInstagramVideoButton, uploadInstagramImageButton])
        secondHorizontalStackView.spacing = 20
        let verticalStackView = UIStackView(arrangedSubviews: [horizontalStackView, secondHorizontalStackView])
        verticalStackView.spacing = 10
        verticalStackView.axis = .vertical
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview()
        
        if viewModel.imagesAllowed {
            uploadImageButton.isHidden = false
            uploadInstagramImageButton.isHidden = false
        }
        
        if viewModel.videosAllowed {
            uploadVideoButton.isHidden = false
            uploadInstagramVideoButton.isHidden = false
        }
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        uploadImageButton.rx.tap.bind(to: viewModel.imageButtonTapped).disposed(by: disposeBag)
        uploadVideoButton.rx.tap.bind(to: viewModel.videoButtonTapped).disposed(by: disposeBag)
        uploadInstagramVideoButton.rx.tap.bind(to: viewModel.instagramVideoButtonTapped).disposed(by: disposeBag)
        uploadInstagramImageButton.rx.tap.bind(to: viewModel.instagramImageButtonTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
