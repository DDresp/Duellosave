//
//  FetchingService_Categories.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

extension FetchingService {
    
    func fetchCategories(orderKey: String, limit: Int?, startId: String?) -> Observable<[CategoryModel]> {
        return fetchDocuments(for: CATEGORY_REFERENCE, orderKey: orderKey, limit: limit, startId: startId).map { (docs) -> [CategoryModel] in
            guard let documents = docs else { throw DownloadError.noData }
            var categories = [CategoryModel]()
            for document in documents {
                let data = document.data()
                let id = document.documentID
                if let category = self.configureCategory(data: data, categoryId: id) {
                    categories.append(category)
                }
            }
            return categories
        }
    }
    
    func configureCategory(data: [String: Any], categoryId: String) -> CategoryModel? {
        var category = Category()
        category.configure(with: data, id: categoryId)
        return category
    }

}

