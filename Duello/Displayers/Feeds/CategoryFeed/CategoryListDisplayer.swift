//
//  CategoryListDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CategoryListDisplayer: class {
    
    //MARK: - Bindables
    var willDisplayCell: PublishRelay<Int> { get }
    
    var reload: PublishRelay<Void> { get }
    var insert: PublishRelay<(Int, Int)> { get }
    
    //MARK: - Getters
    var numberOfCategoryDisplayers: Int { get }
    func getCategoryDisplayer(at index: Int) -> CategoryDisplayer?
    
    //MARK: - Methods
    func update(with loadedCategories: [CategoryModel], fromStart: Bool)
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }
    
}
