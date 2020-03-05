//
//  UploadSingleImagePostDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

protocol UploadSingleImagePostDisplayer: UploadPostDisplayer {
    
    //MARK: - Variables
    var image: UIImage? { get }
    var imageUrl: URL? { get }
    
}
