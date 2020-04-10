//
//  SingleImagePostDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/10/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SingleImagePostDisplayer: PostDisplayer {
    var imageUrl: BehaviorRelay<URL?> { get }
}
