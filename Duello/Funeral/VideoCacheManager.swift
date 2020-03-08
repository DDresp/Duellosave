//
//  VideoCacheManager.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//import Alamofire
//
//class VideoCacheManager {
//    
//    static let shared = VideoCacheManager()
//    private init(){}
//    
//    private let fileManager = FileManager.default
//    
//    private lazy var cacheDirectoryUrl: URL = {
//        let documentsUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
//        return documentsUrl
//    }()
//    
//    private lazy var tempDirectoryUrl: URL = {
//        let tempUrl = FileManager.default.temporaryDirectory
//        return tempUrl
//    }()
//    
//    private var downloadRequests = [String: DownloadRequest]()
//    
//    func cancelVideoDownload(stringUrl: String) {
//        
//        let destinationFile = directoryForVideo(stringUrl: stringUrl, baseUrl: cacheDirectoryUrl)
//        if let downloadRequest = downloadRequests[destinationFile.absoluteString] {
//            downloadRequest.cancel()
//            downloadRequests.removeValue(forKey: destinationFile.absoluteString)
//        }
//        
//    }
//    
//    func downloadVideo(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void) {
//
//        let file = directoryForVideo(stringUrl: stringUrl, baseUrl: cacheDirectoryUrl)
//        guard !fileManager.fileExists(atPath: file.path) else {
//            completionHandler(Result.success(file))
//            return
//        }
//        
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            return (file, [.removePreviousFile])
//        }
//        
//        let tempFile = directoryForVideo(stringUrl: stringUrl, baseUrl: tempDirectoryUrl)
//        
//        let downloadRequest: DownloadRequest
//        if fileManager.fileExists(atPath: tempFile.path), let data = fileManager.contents(atPath: tempFile.path) {
//            downloadRequest = download(resumingWith: data, to: destination)
//        } else {
//            downloadRequest = download(stringUrl, to: destination)
//        }
//        
//        downloadRequests[file.absoluteString] = downloadRequest
//        
//        downloadRequest.response { [weak self] (defaultDownloadResponse) in
//            //TODO: currently sometimes doesnt seem to return an error if firebase is blocked, returns url although not cached
//            if let _ = defaultDownloadResponse.error {
//                if let resumeData = defaultDownloadResponse.resumeData {
//                    try? resumeData.write(to: tempFile)
//                }
//                return
//            }
//            
//            self?.downloadRequests.removeValue(forKey: file.absoluteString)
//            guard let destinationUrl = defaultDownloadResponse.destinationURL else { return }
//            completionHandler(Result.success(destinationUrl))
//            
//        }
//        
//    }
//    
//    private func directoryForVideo(stringUrl: String, baseUrl: URL) -> URL {
//        var fileURL = URL(string: stringUrl)!.lastPathComponent
//        if !fileURL.hasSuffix(".mp4") {
//            fileURL.append(".mp4")
//        }
//        let file = baseUrl.appendingPathComponent(fileURL)
//        return file
//    }
//    
//}
//
