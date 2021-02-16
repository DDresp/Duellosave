const functions = require("firebase-functions");
const admin = require("firebase-admin");

//In Firebase, the admin adds the reviewed post (if ok) to the verifiedPost collection
exports.verifiedPost = functions.firestore
  .document("verifiedPosts/{postId}")
  .onCreate((snapshot, context) => {
    const postId = context.params.postId;
    const postDoc = admin.firestore().doc(`/posts/${postId}`);
    const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
    const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);
    return postDoc.set({
      isVerified: true,
      reportStatus: "noReport"
    }, {merge: true}).then(() => {
      return reviewDoc.delete().then(() => {
        return reportDoc.delete();
      })
    });
  })