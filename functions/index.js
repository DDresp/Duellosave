const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newReport = require("./newReport");
const verifiedPost = require("./verifiedPost");

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newReport = newReport.newReport;
exports.verifiedPost = verifiedPost.verifiedPost;
