//
//  CategoryCollectionViewDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import UIKit
import Firebase

class CategoryCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionDisplayer
    
    //MARK: - Child Displayers
    var categoryListDisplayer: CategoryListDisplayer { return displayer.categoryListDisplayer }
    
    //MARK: - Variables
    let categoryIdentifier: String
    let footerIdentifier: String
    
    //MARK: - Setup
    init(categoryIdentifier: String, footerIdentifier: String, displayer: CategoryCollectionDisplayer) {
        self.footerIdentifier = footerIdentifier
        self.categoryIdentifier = categoryIdentifier
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !displayer.hasNoCategories else { return 1 }
        return categoryListDisplayer.numberOfCategoryDisplayers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! CategoryCell
        cell.displayer = categoryListDisplayer.getCategoryDisplayer(at: indexPath.item)
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.configure()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! FooterLoadingCell
            cell.displayer = displayer
            return cell
        }
        return UICollectionReusableView()
    }
    
}

