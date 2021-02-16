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
//let DEACTIVATE_POST_REFERENCE = Firestore.firestore().collection("deactivatePosts")
//let ACTIVATE_POST_REFERENCE = Firestore.firestore().collection("activatePosts")

let USER_FAVORITE_CATEGORIES_COLLECTION = "favoriteCategories"
let USER_REPORTED_POSTS_COLLECTION = "reportedPosts"
let USER_REPORTED_CATEGORIES_COLLECTION = "reportedCategories"
let USER_REVIEW_REQUESTS_COLLECTION = "reviewRequests"
let USER_DEACTIVATE_POSTS_COLLECTION = "deactivatePosts"
let USER_ACTIVATE_POSTS_COLLECTION = "activatePosts"
