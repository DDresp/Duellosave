//
//  ImagesPostDisplayer.swift
//  
//
//  Created by Darius Dresp on 4/10/20.
//

import RxSwift
import RxCocoa

protocol ImagesPostDisplayer {
    var imagesSliderDisplayer: ImagesSliderDisplayer { get set }
}
