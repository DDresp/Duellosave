//
//  CategoryPostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryPostCollectionViewModel: PostCollectionViewModel {
    
    init() {
        super.init(listDisplayer: CategoryPostListViewModel(), headerDisplayer: UserHeaderViewModel())
    }
    
}
