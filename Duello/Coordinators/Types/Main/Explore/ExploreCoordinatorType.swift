//
//  ExploreCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import RxSwift

protocol ExploreCoordinatorType: RootCoordinatorType {
    var requestedCategory: PublishSubject<CategoryModel?> { get }
    var requestedAddCategory: PublishSubject<Void> { get }
}
