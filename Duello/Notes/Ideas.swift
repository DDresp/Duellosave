//
//  Ideas.swift
//  Duello
//
//  Created by Darius Dresp on 3/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//Direct to Instagram when the user wants to upload a link, so that he can do it faster and more comfortable

//start video automatically in duello mode

//save Blocked User Collection


//ALL that information in a Report Object

//Map Attribute: Reports
//Map Attribute NetworkFailure -> Attribute corresponding to uid
//Map Attribute Inappropriate -> Attribute corresponding to uid
//Map Attribute FakeUser -> Attribute corresponding to uid
//Map Attribute WrongCategory -> Attribute corresponding to uid


//save the uid, so that the same uid can't account for more counts

//POST NOT WORKING LOGIC
//deactivation logic has to change to be more secure
// --> a post to be deactivated should take at least
// 1) In the User Profile all posts should be downloaded always
// 2) In the Category Feed deactived Posts will be downloaded until they got deactivated 5 times
// 3) In the Duello Feed no Post should be downloaded that got deactivated (no matter how often it got deactivated)


//POST REPORTED LOGIC
//reported Posts should be saved in own collection for review
// 1) Fake User 2) Graphical/Inappropriate Content 3) Wrong Feed 4) I don't like it
//a post that got reported more often should be deactivated also without review, until reviewed


//posts (listeners to reportedPosts and postsForReview)
//reportedPosts (listeners to postsForReview)
//postsForReview
//verifiedPosts (listeners to posts)
//removedPosts (listeners to posts)


//Following idea for storing dictionary objects
// have standard key like user/imageUrl etc
//iterate through the array of images, users you got and set the corresponding index after the standardKey
//save a string like the uid or the imageUrl as the value of the dictionary
