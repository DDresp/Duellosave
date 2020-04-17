const functions = require("firebase-functions");
const admin = require("firebase-admin");

//MARK: - Listeners
exports.newReport = functions.firestore
  .document("users/{uid}/reportedPosts/{postId}")
  .onCreate((snapshot, context) => {
    const uid = context.params.uid;
    const reportData = snapshot.data();
    const reportType = reportData.report;
    return createNewReport(reportType, uid, snapshot.id);
  });

//------------------------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
async function createNewReport(reportType, uid, postId) {
  const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();
  const countField = reportType + "Count";

  const postDoc = admin.firestore().doc(`/posts/${postId}`);
  const postSnapshot = await postDoc.get();
  const postData = postSnapshot.data();

  if (reportData) {
    if (reportData[countField]) {
      return reportDoc.update({
        [countField]: admin.firestore.FieldValue.increment(1),
        post: postData,
      });
    }
  }

  var newReport = {};
  newReport.post = postData;
  newReport[countField] = 1;
  return reportDoc.set(newReport, { merge: true });
}