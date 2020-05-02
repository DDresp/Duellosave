const functions = require("firebase-functions");
const admin = require("firebase-admin");

//MARK: - Listeners
exports.deletedPost = functions.firestore
  .document("posts/{postId}")
  .onDelete((snapshot, context) => {
    const postId = context.params.postId;

    const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
    const reportedDoc = admin.firestore().doc(`/reportedPosts/${postId}`);

    return reviewDoc.delete().then(() => {
      return reportedDoc.delete();
    });
  });
