//
//  UploadingService_Category.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import Firebase
import RxSwift

extension UploadingService {
    
    func create(category: CategoryModel?) -> Observable<CategoryModel?> {
        guard let category = category else { return
            Observable.error(UploadingError.unknown(description: "unknown error"))
        }
        let id = UUID().uuidString
        return saveCategory(category: category, categoryId: id)
    }
    
    private func saveCategory(category: CategoryModel, categoryId: String) -> Observable<CategoryModel?> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError) }
        
        return self.saveDatabaseModel(databaseModel: category, reference: CATEGORY_REFERENCE, id: categoryId).map { (model) -> CategoryModel? in
            guard let categoryModel = model as? CategoryModel else { throw UploadingError.unknown(description: "unknown error")}
            return categoryModel
        }
    }
    
}

