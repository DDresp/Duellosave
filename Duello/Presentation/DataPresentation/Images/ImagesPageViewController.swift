//
//  ImagesPageViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import SDWebImage
import RxSwift
import RxCocoa

class ImagesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: - Displayer
    var displayer: ImagesSliderDisplayer? {
        
        didSet {
            disposeBag = DisposeBag()
            setupBindablesFromDisplayer()
            
        }
    }
    
    //MARK: - Variables
    var controllers = [UIViewController]()
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VERYLIGHTGRAYCOLOR
        dataSource = self
        delegate = self
        
    }
    
    //MARK: - Delegation and Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = controllers.firstIndex { (photoController) -> Bool in
            return photoController == viewController
            } ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = controllers.firstIndex { (photoController) -> Bool in
            return photoController == viewController
            } ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentViewController = viewControllers?.first else { return }
        if let index = controllers.firstIndex(of: currentViewController) {
            displayer?.selectedImageIndex.accept(index)
        }
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    func setupBindablesFromDisplayer() {
        
        displayer?.imageUrls.subscribe(onNext: { [weak self] (imageUrls) in
            guard let self = self else { return }
            guard let urls = imageUrls else { return }
            let newControllers = urls.map({ (url) -> ImageViewController in
                let controller = ImageViewController()
                controller.setImageUrl(imageUrl: url)
                return controller
            })
            
            self.controllers = newControllers
            guard let index = self.displayer?.selectedImageIndex.value else { return }
            let controller = self.controllers[index]
            self.setViewControllers([controller], direction: .forward, animated: false)
            
        }).disposed(by: disposeBag)
        
        displayer?.images.subscribe(onNext: { [weak self] (images) in
            guard let self = self else { return }
            guard let images = images else { return }
            let newControllers = images.map({ (image) -> ImageViewController in
                let controller = ImageViewController()
                controller.setImage(image: image)
                return controller
            })
            
            self.controllers = newControllers
            guard let index = self.displayer?.selectedImageIndex.value else { return }
            let controller = self.controllers[index]
            self.setViewControllers([controller], direction: .forward, animated: false)
            
        }).disposed(by: disposeBag)
        
    }
    
}
