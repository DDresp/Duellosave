//
//  CategoryDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa


protocol CategoryDisplayer {
    
    //MARK: - Variables
    var index: Int { get }
    var title: String { get }
    var description: String { get }
    var categoryId: String { get }
    
    //MARK: - Bindables
    var goToMe: PublishRelay<Int?> { get }
    var tapped: PublishSubject<Void> { get }
    
}

