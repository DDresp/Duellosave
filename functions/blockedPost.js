const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.blockedPost = functions.firestore
  .document("blockedPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
    const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);

    const data = snapshot.data();
    if (data) {
      const reportType = data.reportType;
      if (reportType) {
        return postDoc
          .set(
            {
              isBlocked: 1,
              reportStatus: reportType,
            },
            { merge: true }
          )
          .then(() => {
            return reviewDoc.delete().then(() => {
              return reportDoc.delete();
            });
          });
      }
    }
  });
