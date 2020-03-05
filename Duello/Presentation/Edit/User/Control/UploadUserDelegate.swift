//
//  UploadUserDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class UploadUserDelegate: NSObject, UITableViewDelegate {
    
    //MARK: - Displayer
    var displayer: UploadUserDisplayer
    
    //MARK: - Setup
    init(displayer: UploadUserDisplayer) {
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Delegation
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let headerLabel = SmallHeaderLabel()
        headerLabel.text = displayer.getUploadUserItemDisplayer(at: section).title
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
        return UITableView.automaticDimension
    }
    
}
