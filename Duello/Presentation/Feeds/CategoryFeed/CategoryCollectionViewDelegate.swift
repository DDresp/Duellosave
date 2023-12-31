//
//  CategoryCollectionViewDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionDisplayer

    //MARK: - Child Displayers
    var categoryListDisplayer: CategoryListDisplayer { return displayer.categoryListDisplayer }
    
    //MARK: - Variables
    weak var collectionView: UICollectionView?
    
    private lazy var categoryCell = CategoryCell(frame: .init(x: 0, y: 0, width: frameWidth - 30, height: 1000))
    
    //MARK: - Setup
    init(displayer: CategoryCollectionDisplayer, collectionView: UICollectionView) {
        self.displayer = displayer
        self.collectionView = collectionView
        super.init()
    }

    //MARK: - Delegation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryListDisplayer.getCategoryDisplayer(at: indexPath.item)?.tapped.accept(())
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if displayer.hasNoCategories || displayer.allDataLoaded.value {
            return .init(width: frameWidth, height: STANDARDSPACING)
        }
        return .init(width: frameWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryViewModel = categoryListDisplayer.getCategoryDisplayer(at: indexPath.item)
        categoryCell.displayer = categoryViewModel
        categoryCell.fit()
        let size = categoryCell.systemLayoutSizeFitting(.init(width: frameWidth - 30, height: 1000))
        return CGSize(width: frameWidth - 30, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        categoryListDisplayer.willDisplayCell.accept(indexPath.row)
    }
    
    //MARK: - Getters
    private lazy var frameWidth: CGFloat = {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width
    }()
    
}

