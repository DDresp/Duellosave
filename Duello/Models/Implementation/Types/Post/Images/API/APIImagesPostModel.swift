//
//  APIImagesPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

protocol ApiImagesPostModel: ImagesPostModel {
    func downloadImageUrls() -> Observable<[URL]?>
}
