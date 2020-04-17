const admin = require("firebase-admin");

admin.initializeApp();

const reportedPosts = require("./reportedPosts");
const newReport = require("./newReport");

exports.reportedPosts = reportedPosts.reportedPosts;
exports.newReport = newReport.newReport;
