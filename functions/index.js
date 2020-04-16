const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

async function createNewReport(reportType, uid, postId) {
  const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();
  const countField = reportType + "Count";

  if (reportData) {
    if (reportData[countField]) {
      return reportDoc.update({
        [countField]: admin.firestore.FieldValue.increment(1)
      });
    } else {
      var report = {};
      report[countField] = 1;
      return reportDoc.set(report, { merge: true });
    }
  } else {
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const postSnapshot = await postDoc.get();
    const postData = postSnapshot.data();
    var report = {};
    report.post = postData;
    report[countField] = 1;
    return reportDoc.set(report);
  }
}

//User is only allowed to report once and only one reportType!
//Thus, this function only listens to "onCreate"
exports.onReport = functions.firestore
  .document("users/{uid}/reportedPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const uid = context.params.uid;
    const reportData = snapshot.data();
    const reportType = reportData.report;
    return createNewReport(reportType, uid, snapshot.id);
  });