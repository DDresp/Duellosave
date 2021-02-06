//
//  ImagesPostDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/11/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol ImagesPostDisplayer: PostDisplayer {
    var imagesSliderDisplayer: ImagesSliderDisplayer { get }
}
