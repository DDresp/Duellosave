const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newPostReport = require("./newPostReport");
const newPostReviewRequest = require("./newPostReviewRequest");
const verifiedPost = require("./verifiedPost");
const blockedPost = require("./blockedPost");
const deletedPost = require("./deletedPost");
const newCategoryReport = require("./newCategoryReport")

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newPostReport = newPostReport.newPostReport;
exports.newPostReviewRequest = newPostReviewRequest.newPostReviewRequest;
exports.verifiedPost = verifiedPost.verifiedPost;
exports.blockedPost = blockedPost.blockedPost;
exports.deletedPost = deletedPost.deletedPost;
exports.newCategoryReport = newCategoryReport.newCategoryReport;
