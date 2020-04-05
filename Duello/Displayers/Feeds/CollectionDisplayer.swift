//
//  CollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa

protocol CollectionDisplayer {
    var finished: BehaviorRelay<Bool> { get }
}
