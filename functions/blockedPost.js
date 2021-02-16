const functions = require("firebase-functions");
const admin = require("firebase-admin");

//In Firebase, the admin adds the reviewed post (if not ok) to the blockedPost collection
exports.blockedPost = functions.firestore
  .document("blockedPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
    const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);

    const data = snapshot.data();
    if (data) {
      const reportStatus = data.reportStatus;
      if (reportStatus) {
        return postDoc
          .set(
            {
              isBlocked: true,
              reportStatus: reportStatus,
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
