//
//  UploadPostDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class UploadPostDelegate: NSObject, UITableViewDelegate {
    
    //MARK: - Displayer
    var displayer: UploadPostDisplayer
    
    //MARK: - Variables
    private let mediaCellId: String
    private let titleCellId: String
    private let descriptionCellId: String
    
    private let mediaCellSection = 0
    private let titleCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(mediaCellId: String, titleCellId: String, descriptionCellId: String, displayer: UploadPostDisplayer) {
        self.displayer = displayer
        self.mediaCellId = mediaCellId
        self.titleCellId = titleCellId
        self.descriptionCellId = descriptionCellId
        super.init()
    }
    
    //MARK: - Delegation
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch section {
        case mediaCellSection:
            return nil
        case descriptionCellSection:
            let header = UploadDescriptionHeader()
            header.displayer = displayer.descriptionDisplayer
            return header
        case titleCellSection:
            let label = SmallHeaderLabel()
            label.text = "TITLE"
            return label
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == mediaCellSection { return 0}
        return 35
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if mediaCellSection == indexPath.section {
            return 400
        } else {
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.section == mediaCellSection else {
            return UITableView.automaticDimension
        }
        var mediaRatio = displayer.mediaRatio ?? 1
        mediaRatio = max(mediaRatio, MINMEDIAHEIGHTRATIO)
        mediaRatio = min(mediaRatio, MAXMEDIAHEIGHTRATIO)
        return tableView.frame.width * CGFloat(mediaRatio)
    }
    
}
