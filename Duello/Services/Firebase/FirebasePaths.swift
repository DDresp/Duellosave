//
//  FirebasePaths.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import FirebaseFirestore

let USERS_REFERENCE = Firestore.firestore().collection("users")
let POST_REFERENCE = Firestore.firestore().collection("posts")
let CATEGORY_REFERENCE = Firestore.firestore().collection("categories")

let INAPPROPRIATE_REPORT = "inappropriateReports"
let IN_WRONG_CATEGORY_REPORT = "inWrongCategoryReports"
let FROM_FAKE_USER_REPORT = "fromFakeUserReports"
