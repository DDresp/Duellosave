const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newReport = require("./newReport");
const verifiedPost = require("./verifiedPost");
const blockedPost = require("./blockedPost");

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newReport = newReport.newReport;
exports.verifiedPost = verifiedPost.verifiedPost;
exports.blockedPost = blockedPost.blockedPost;
