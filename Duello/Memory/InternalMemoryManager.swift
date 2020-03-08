//
//  InternalMemoryManager.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import FirebaseFirestore

class InternalMemoryManager {
    
    static let shared = InternalMemoryManager()
    private init(){}
    
    //MARK: - Save Snapshots for Pagination
    private var snapshots = [String: DocumentSnapshot]()
    
    func memorize(snapshot: DocumentSnapshot, with path: String) {
        snapshots[path] = snapshot
    }
    
    func retrieveSnapshot(from path: String) -> DocumentSnapshot? {
        defer { snapshots[path] = nil }
        return snapshots[path]
    }
    
}
