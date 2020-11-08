//
//  SocialMediaCollectionViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class SocialMediaCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Displayer
    var displayer: SocialMediaDisplayer? {
        didSet {
            
            guard let displayer = displayer else { return }
            disposeBag = DisposeBag()
            setupBindablesFromDisplayer()
            datasource.displayer = displayer
            collectionView.backgroundColor = displayer.isDarkMode ? ULTRADARKCOLOR : DARKCOLOR
            
        }
    }
    
    //MARK: - Variables
    private let cellId = "CellId"
    lazy var datasource = SocialMediaDatasource(cellIdentifier: cellId)
    
    //MARK: - Setup
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.dataSource = datasource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = ULTRADARKCOLOR
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        
        collectionView.register(SocialMediaCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    //MARK: - Delegation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let size = displayer?.sizes[indexPath.item] {
            return size
        } else {
            let estimatedSizeCell = SocialMediaCell(frame: .init(x: 0, y: 0, width: 1000, height: self.view.frame.height))
            estimatedSizeCell.displayer = displayer?.getItemDisplayer(for: indexPath)
            estimatedSizeCell.layoutIfNeeded()
            let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: 1000, height: self.view.frame.height))
            let size: CGSize = .init(width: estimatedSize.width, height: self.view.frame.height)
            displayer?.sizes[indexPath.item] = size
            return size
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return STANDARDSPACING + 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if displayer?.itemHasLink(for: indexPath) == true {
            let cell = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { finished in UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)})
            
        }
        
        displayer?.selectedItemIndex.accept(indexPath.item)
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()

    func setupBindablesFromDisplayer() {
        
        displayer?.reloadData.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.collectionView.reloadData()
            self?.collectionView.setContentOffset(.init(x: -STANDARDSPACING, y: 0), animated: false)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
