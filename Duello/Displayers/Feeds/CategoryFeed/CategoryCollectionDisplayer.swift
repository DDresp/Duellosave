//
//  CategoryCollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CategoryCollectionDisplayer: class, CollectionDisplayer {
    
    //MARK: - Models
    var categories: BehaviorRelay<[CategoryModel]?> { get }
  
    //MARK: - Child Displayers
    var categoryListDisplayer: CategoryListDisplayer { get }
    
    //MARK: - Bindables
    var needsRestart: BehaviorRelay<Bool> { get }
    var refreshChanged: PublishSubject<Void> { get }
    
    var insertData: PublishRelay<(Int, Int)> { get }
    var reloadData: PublishRelay<Void> { get }
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> { get }

    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }

}

extension CategoryCollectionDisplayer {
    //MARK: - Getter
    var hasNoCategories: Bool { return categories.value?.count == 0 }
    
}
