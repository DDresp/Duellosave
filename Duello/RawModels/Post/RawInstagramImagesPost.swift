//
//  RawInstagramImagesPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

struct RawInstagramImagesPost: RawInstagramPostType {
    var imageUrls: [URL]
    var mediaRatio: Double
    var apiLink: String
}
