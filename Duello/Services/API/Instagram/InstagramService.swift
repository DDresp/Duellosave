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
            
            Alamofire.request(url).validate().responseJSON(completionHandler: { (response) in

                if response.result.isFailure {
                    if let statusCode = response.response?.statusCode, statusCode == 404 {
                        return observer.onError(InstagramError.deactive)
                    } else {
                        return observer.onError(InstagramError.unknown(description: "Unknown Error."))
                    }
                }

                if let result = response.result.value as? [String: Any] {
                    observer.onNext(result.description)
                    observer.onCompleted()
                }

            })
            return Disposables.create()
            
        })
    }
    
    func getValuesForQueryKey(key: String, from instagramDescription: String, valueIsStringEncoded: Bool = true, keyIsStringEncoded: Bool = true) -> [String] {
        
        let queryKey: String
        if keyIsStringEncoded {
            queryKey = "\"\(key)\""
        } else {
            queryKey = "\(key)"
        }
        
        var values = [String]()
        
        if valueIsStringEncoded {
            for range in instagramDescription.ranges(of: queryKey) {
                if let startIndex = instagramDescription.range(of: "\"", options: .init(), range: range.upperBound..<instagramDescription.endIndex) {
                    if let endIndex = instagramDescription.range(of: "\"", options: .init(), range: startIndex.upperBound..<instagramDescription.endIndex) {
                        let value = String(instagramDescription[startIndex.upperBound..<endIndex.lowerBound])
                        values.append(value)
                    }
                }
            }
        } else {
            
            for range in instagramDescription.ranges(of: queryKey) {
                let substring = String(instagramDescription.suffix(from: range.upperBound))
                let string = String(substring.split(separator: " ")[1]) //[0] would be "="
                let finalString = string.dropLast().dropLast() //removes ";")
                values.append(String(finalString))
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
    
    func extractMediaRatio(from description: String) -> Double {
        
        let heights = getValuesForQueryKey(key: "height", from: description, valueIsStringEncoded: false, keyIsStringEncoded: false)
        let widths = getValuesForQueryKey(key: "width", from: description, valueIsStringEncoded: false, keyIsStringEncoded: false)
        
        guard let height = heights.first else { return 1 }
        guard let width = widths.first else { return 1 }

        let doubleHeight = Double(height) ?? 1.0
        let doubleWidth = Double(width) ?? 1.0
        
        let ratio = doubleHeight / doubleWidth
        return ratio
        
    }
}
