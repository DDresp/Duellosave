const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

async function createReport(reportDoc, uid, postId) {
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();

  if (reportData) {
    const reportUids = reportData.uids;
    reportUids.push(uid);
    return reportDoc.update({
      uids: reportUids,
      count: admin.firestore.FieldValue.increment(1)
    });
  } else {
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const postSnapshot = await postDoc.get();
    const postData = postSnapshot.data();
    return reportDoc.set({ uids: [uid], post: postData, count: 1 });
  }
}

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

    // return reportDoc.update({
    //     countField: admin.firestore.FieldValue.increment(1)
    // });
    // const reportUids = reportData.uids;
    // reportUids.push(uid);
    // return reportDoc.update({
    //   uids: reportUids,
    //   count: admin.firestore.FieldValue.increment(1)
    // });
  } else {
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const postSnapshot = await postDoc.get();
    const postData = postSnapshot.data();
    var report = {};
    report.post = postData;
    report[countField] = 1;
    return reportDoc.set(report);

    // return reportDoc.set({ countField: 1 });
  }

  // if (reportData) {
  //   const reportUids = reportData.uids;
  //   reportUids.push(uid);
  //   return reportDoc.update({
  //     uids: reportUids,
  //     count: admin.firestore.FieldValue.increment(1)
  //   });
  // } else {
  //   const postDoc = admin.firestore().doc(`/posts/${postId}`);
  //   const postSnapshot = await postDoc.get();
  //   const postData = postSnapshot.data();
  //   return reportDoc.set({ uids: [uid], post: postData, count: 1 });
  // }
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

    // switch (reportTypeString) {
    //     case "inappropriate":
    //         break;
    //     case "wrongCategory":
    //         break;
    //     case "fakeUser":
    //         break;
    // }
  });

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
