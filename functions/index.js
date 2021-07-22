const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newPostReport = require("./newPostReport");
const newPostReviewRequest = require("./newPostReviewRequest");
const verifiedPost = require("./verifiedPost");
const blockedPost = require("./blockedPost");
const deletedPost = require("./deletedPost");

const reportedCategories = require("./reportedCategories");
const newCategoryReport = require("./newCategoryReport");

const numberOfPosts = require("./numberOfPosts");
// const { exampleDocumentSnapshot } = require("firebase-functions-test/lib/providers/firestore");

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newPostReport = newPostReport.newPostReport;
exports.newPostReviewRequest = newPostReviewRequest.newPostReviewRequest;
exports.verifiedPost = verifiedPost.verifiedPost;
exports.blockedPost = blockedPost.blockedPost;
exports.deletedPost = deletedPost.deletedPost;

exports.reportedCategories = reportedCategories.reportedCategories;
exports.newCategoryReport = newCategoryReport.newCategoryReport;

exports.addNumberOfPosts = numberOfPosts.addNumberOfPosts;
exports.subtractNumberOfPosts = numberOfPosts.subtractNumberOfPosts;