//
//  InstagramService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Alamofire
import RxSwift

class InstagramService: NetworkService {
    
    static let shared = InstagramService()
    
    private init() {}
    
    //MARK: General
    func downloadDescription(link: String) -> Observable<String> {
        return Observable.create({ [weak self] (observer) -> Disposable in

            guard let apiLink = self?.createAPILink(for: link), let url = URL(string: apiLink) else {
                observer.onError(InstagramError.unknown(description: "Unknown Error."))
                return Disposables.create()
            }
            
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                if response.result.isFailure {
                    return observer.onError(InstagramError.deactive)
                }
                
                if let result = response.result.value as? [String: Any] {
                    observer.onNext(result.description)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
            
        })
    }
    
    func getValuesForQueryKey(key: String, from instagramDescription: String) -> [String] {
        
        let queryKey = "\"\(key)\""
        var values = [String]()
        
        for range in instagramDescription.ranges(of: queryKey) {
            if let startIndex = instagramDescription.range(of: "\"", options: .init(), range: range.upperBound..<instagramDescription.endIndex) {
                if let endIndex = instagramDescription.range(of: "\"", options: .init(), range: startIndex.upperBound..<instagramDescription.endIndex) {
                    let value = String(instagramDescription[startIndex.upperBound..<endIndex.lowerBound])
                    values.append(value)
                }
            }
        }
        return values
    }
    
    
    private func createAPILink(for link: String) -> String? {
        
        guard var instaLinkString = link.toInstagramLink() else { return nil }
        
        if let lastSlashIndex = instaLinkString.range(of: "/", options: .backwards)?.upperBound {
            let instaLinkSuffix = instaLinkString[lastSlashIndex..<instaLinkString.endIndex]
            //This means an additional queryKey is added after the link, this happens currently if the user "copies" a link on instagram instead of taking the instagram url directly
            if instaLinkSuffix.hasPrefix("?") {
                instaLinkString = String(instaLinkString[instaLinkString.startIndex..<lastSlashIndex])
            }
        }
        return instaLinkString + "?__a=1"
    }
}
