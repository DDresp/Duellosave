//
//  RawInstagramVideoPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

struct RawInstagramVideoPost: RawInstagramPostType {
    var videoURL: URL
    var thumbnailUrl: URL
    var apiLink: String
}
