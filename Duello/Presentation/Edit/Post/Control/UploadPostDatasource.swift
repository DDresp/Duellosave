//
//  UploadPostDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

class UploadPostDatasource: NSObject, UITableViewDataSource {
    
    //MARK: - Displayer
    var displayer: UploadPostDisplayer
    
    //MARK: - Variables
    weak var parentViewController: UIViewController?
    
    let mediaCellId: String
    let titleCellId: String
    let descriptionCellId: String
    
    private let mediaCellSection = 0
    private let titleCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(mediaCellId: String, titleCellId: String, descriptionCellId: String, displayer: UploadPostDisplayer, parentViewController: UIViewController) {
        self.mediaCellId = mediaCellId
        self.titleCellId = titleCellId
        self.descriptionCellId = descriptionCellId
        self.displayer = displayer
        self.parentViewController = parentViewController
        super.init()
    }
    
    //MARK: - Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case mediaCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: mediaCellId, for: indexPath)
            
            switch displayer {
            case let viewModel as UploadSingleImagePostDisplayer:
                (cell as! UploadSingleImageMediaPostCell).displayer = viewModel
                return cell
            case let viewModel as UploadImagesPostDisplayer:
                (cell as! UploadImagesMediaPostCell).displayer = viewModel
                (cell as! UploadImagesMediaPostCell).parentViewController = parentViewController
                return cell
            case let viewModel as UploadVideoPostDisplayer:
                (cell as! UploadVideoMediaPostCell).displayer = viewModel
                return cell
            default:
                return UITableViewCell()
            }
            
        case titleCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCellId, for: indexPath) as! UploadPostTitleCell
            cell.displayer = displayer.titleDisplayer
            return cell
            
        case descriptionCellSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! UploadPostDescriptionCell
            cell.displayer = displayer.descriptionDisplayer
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}
