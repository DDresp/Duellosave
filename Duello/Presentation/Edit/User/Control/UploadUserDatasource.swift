//
//  UploadUserDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

class UploadUserDatasource: NSObject, UITableViewDataSource {
    
    //MARK: - Displayer
    var displayer: UploadUserDisplayer
    
    //MARK: - Setup
    init(displayer: UploadUserDisplayer) {
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayer.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let header = UploadUserHeaderCell()
            header.displayer = displayer.getUploadUserHeaderDisplayer()
            return header
        }
        
        let cell = UploadUserTableViewCell()
        cell.displayer = displayer.getUploadUserItemDisplayer(at: indexPath.section)
        return cell
    }
    
}
