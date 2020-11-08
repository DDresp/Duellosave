//
//  ImagesSlider.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ImagesSlider: UIView {
    
    //MARK: - Displayer
    var displayer: ImagesSliderDisplayer? {
        didSet {
            
            disposeBag = DisposeBag()
            pageViewController.displayer = displayer
            setupBindablesFromDisplayer()
            
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: - Views
    private var pageViewController: ImagesPageViewController = {
         let controller = ImagesPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
         return controller
     }()
     
     private var pageControl: UIPageControl = {
         let pageControl = UIPageControl()
         pageControl.currentPageIndicatorTintColor = EXTREMELIGHTGRAYCOLOR
         pageControl.pageIndicatorTintColor = UIColor.gray
         pageControl.isUserInteractionEnabled = false
         pageControl.translatesAutoresizingMaskIntoConstraints = false
         pageControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
         return pageControl
     }()
     
     private lazy var pageControlContainerView: UIView = {
         let view = UIView()
         view.backgroundColor = ULTRADARKCOLOR
         view.addSubview(pageControl)
         pageControl.fillSuperview()
         return view
     }()
     
     private lazy var stackView: UIStackView = {
         let stackView = UIStackView(arrangedSubviews: [pageViewController.view, pageControlContainerView])
         stackView.axis = .vertical
         return stackView
     }()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        
        displayer.selectedImageIndex.asObservable().subscribe(onNext: { [weak self] (index) in
            self?.pageControl.currentPage = index
        }).disposed(by: disposeBag)
        
        displayer.images.subscribe(onNext: { [weak self] (images) in
            guard let images = images else { return }
            self?.pageControl.numberOfPages = images.count
        }).disposed(by: disposeBag)
        
        displayer.imageUrls.subscribe(onNext: { [weak self] (urls) in
            guard let urls = urls else { return }
            self?.pageControl.numberOfPages = urls.count
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(displayer.images, displayer.imageUrls).map { (images, urls) -> Bool in
            return images == nil && urls == nil
            }.bind(to: rx.isHidden).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
