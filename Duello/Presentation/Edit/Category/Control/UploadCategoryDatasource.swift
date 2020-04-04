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
    
    let titleCellId: String
    let imagesSelectorCellId: String
    let videoSelectorCellId: String
    let descriptionCellId: String
    
    private let titleCellSection = 0
    private let typeCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(titleCellId: String, descriptionCellId: String, imageSelectorCellId: String, videoSelectorCellId: String, displayer: UploadCategoryDisplayer, parentViewController: UIViewController) {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == typeCellSection {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case titleCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCellId, for: indexPath) as! UploadTitleCell
            cell.displayer = displayer.titleDisplayer
            return cell
            
        case descriptionCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! UploadDescriptionCell
            cell.displayer = displayer.descriptionDisplayer
            return cell
            
        case typeCellSection:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: imagesSelectorCellId, for: indexPath) as! UploadImagesSelectorCell
                cell.displayer = displayer.typeSelectorDisplayer
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: videoSelectorCellId, for: indexPath) as! UploadVideoSelectorCell
                cell.displayer = displayer.typeSelectorDisplayer
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }
    
}
