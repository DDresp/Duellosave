//
//  UploadCategoryDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class UploadCategoryDelegate: NSObject, UITableViewDelegate {
    
    //MARK: - Displayer
    var displayer: UploadCategoryDisplayer
    
    //MARK: - Variables
    private let titleCellId: String
    private let imagesSelectorCellId: String
    private let videoSelectorCellId: String
    private let descriptionCellId: String
    
    private let titleCellSection = 0
    private let typeCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(titleCellId: String, descriptionCellId: String, imageSelectorCellId: String, videoSelectorCellId: String, displayer: UploadCategoryDisplayer) {
        self.displayer = displayer
        self.titleCellId = titleCellId
        self.imagesSelectorCellId = imageSelectorCellId
        self.videoSelectorCellId = videoSelectorCellId
        self.descriptionCellId = descriptionCellId
        super.init()
    }
    
    //MARK: - Delegation
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case descriptionCellSection:
            let header = UploadPostDescriptionHeader()
            header.displayer = displayer.descriptionDisplayer
            return header
        case titleCellSection:
            let label = SmallHeaderLabel()
            label.text = "TITLE"
            return label
        case typeCellSection:
            let label = SmallHeaderLabel()
            label.text = "MEDIA ALLOWED"
            return label
        default:
            return nil
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == descriptionCellSection {
            return 55
        } else {
            return 35
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if typeCellSection == indexPath.section {
            return 50
        }
        return UITableView.automaticDimension
    }
}
