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
    private let coverImageCellId: String
    private let titleCellId: String
    private let imagesSelectorCellId: String
    private let videoSelectorCellId: String
    private let descriptionCellId: String
    
    private let coverImageCellSection = 0
    private let titleCellSection = 1
    private let selectorCellSection = 2
    private let descriptionCellSection = 3
    
    //MARK: - Setup
    init(coverImageCellId: String, titleCellId: String, descriptionCellId: String, imageSelectorCellId: String, videoSelectorCellId: String, displayer: UploadCategoryDisplayer) {
        self.displayer = displayer
        self.coverImageCellId = coverImageCellId 
        self.titleCellId = titleCellId
        self.imagesSelectorCellId = imageSelectorCellId
        self.videoSelectorCellId = videoSelectorCellId
        self.descriptionCellId = descriptionCellId
        super.init()
    }
    
    //MARK: - Delegation
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case coverImageCellSection:
            return UploadSimpleHeader(title: "COVER IMAGE")
        case descriptionCellSection:
            let header = UploadDescriptionHeader()
            header.displayer = displayer.descriptionDisplayer
            return header
        case titleCellSection:
            return UploadSimpleHeader(title: "TITLE")
        case selectorCellSection:
            return UploadSimpleHeader(title: "MEDIA")
        default:
            return nil
        }
        
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == descriptionCellSection {
            return 55
        } else {
            return 35
        }
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == coverImageCellSection {
            return 300
        } else if indexPath.section == selectorCellSection {
            return 80
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if coverImageCellSection == indexPath.section {
            return tableView.frame.width
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == titleCellSection {
            return 15
        } else {
            return 5
        }
    }
}
