//
//  SocialMediaItemDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol SocialMediaItemDisplayer {
    
    //MARK: - Variables
    var link: UserSingleAttribute? { get }
    var socialMediaName: String { get }
    var hasLink: Bool { get }
    var iconName: String { get }
    var isDarkMode: Bool { get }
}
