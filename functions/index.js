const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

async function createReport(reportDoc, uid, postId) {
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();

  if (reportData) {
    const reportUids = reportData.uids;
    reportUids.push(uid);
    return reportDoc.set({ uids: reportUids }, { merge: true });
  } else {
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const postSnapshot = await postDoc.get();
    const postData = postSnapshot.data();
    return reportDoc.set({ uids: [uid], post: postData });
  }
}

exports.onInappropriateReport = functions.firestore
  .document("users/{uid}/inappropriateReports/{postId}")
  .onCreate(async (snapshot, context) => {
    const reportDoc = admin
      .firestore()
      .doc(`/inappropriatePosts/${snapshot.id}`);
    const uid = context.params.uid;
    return createReport(reportDoc, uid, snapshot.id);
  });

exports.onInWrongCategoryReport = functions.firestore
  .document("users/{uid}/inWrongCategoryReports/{postId}")
  .onCreate(async (snapshot, context) => {
    const reportDoc = admin
      .firestore()
      .doc(`/inWrongCategoryPosts/${snapshot.id}`);
    const uid = context.params.uid;
    return createReport(reportDoc, uid, snapshot.id);
  });

exports.onFromFakeUserReport = functions.firestore
  .document("users/{uid}/fromFakeUserReports/{postId}")
  .onCreate(async (snapshot, context) => {
    const reportDoc = admin
      .firestore()
      .doc(`/fromFakeUserPosts/${snapshot.id}`);
    const uid = context.params.uid;
    return createReport(reportDoc, uid, snapshot.id);
  });
