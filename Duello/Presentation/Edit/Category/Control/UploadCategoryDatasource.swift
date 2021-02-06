//
//  UploadCategoryDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class UploadCategoryDatasource: NSObject, UITableViewDataSource {
    
    //MARK: - Displayer
    var displayer: UploadCategoryDisplayer
    
    //MARK: - Variables
    weak var parentViewController: UIViewController?
    
    let coverImageCellId: String
    let titleCellId: String
    let imagesSelectorCellId: String
    let videoSelectorCellId: String
    let descriptionCellId: String
    
    private let coverImageCellSection = 0
    private let titleCellSection = 1
    private let selectorCellSection = 2
    private let descriptionCellSection = 3
    
    //MARK: - Setup
    init(coverImageCellId: String, titleCellId: String, descriptionCellId: String, imageSelectorCellId: String, videoSelectorCellId: String, displayer: UploadCategoryDisplayer, parentViewController: UIViewController) {
        self.coverImageCellId = coverImageCellId
        self.titleCellId = titleCellId
        self.descriptionCellId = descriptionCellId
        self.imagesSelectorCellId = imageSelectorCellId
        self.videoSelectorCellId = videoSelectorCellId
        self.displayer = displayer
        self.parentViewController = parentViewController
        super.init()
    }
    
    //MARK: - Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selectorCellSection {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case coverImageCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: coverImageCellId, for: indexPath) as! UploadCategoryImageCell
            cell.displayer = displayer
            return cell
            
        case titleCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCellId, for: indexPath) as! UploadTitleCell
            cell.displayer = displayer.titleDisplayer
            return cell
            
        case descriptionCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! UploadDescriptionCell
            cell.displayer = displayer.descriptionDisplayer
            return cell
            
        case selectorCellSection:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: imagesSelectorCellId, for: indexPath) as! UploadImagesSelectorCell
                cell.displayer = displayer.roughMediaSelectorDisplayer
                cell.layoutIfNeeded()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: videoSelectorCellId, for: indexPath) as! UploadVideoSelectorCell
                cell.displayer = displayer.roughMediaSelectorDisplayer
                cell.layoutIfNeeded()
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }

}
