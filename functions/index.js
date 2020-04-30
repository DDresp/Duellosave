const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newReport = require("./newReport");
const newReviewRequest = require("./newReviewRequest");
const verifiedPost = require("./verifiedPost");
const blockedPost = require("./blockedPost");

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newReport = newReport.newReport;
exports.newReviewRequest = newReviewRequest.newReviewRequest;
exports.verifiedPost = verifiedPost.verifiedPost;
exports.blockedPost = blockedPost.blockedPost;
