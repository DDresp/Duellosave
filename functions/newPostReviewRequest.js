const functions = require("firebase-functions");
const admin = require("firebase-admin");

//MARK: - Listeners
exports.newPostReviewRequest = functions.firestore
  .document("users/{uid}/reviewPostRequests/{postId}")
  .onCreate((snapshot, context) => {
    return createNewReview(snapshot.id);
  });

//------------------------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
async function createNewReview(postId) {

  const postDoc = admin.firestore().doc(`/posts/${postId}`);
  const postSnapshot = await postDoc.get();
  const postData = postSnapshot.data();

  const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);

  var review = {
    post: postData,
    userInitiatedReview: true,
  };

  postDoc
    .set(
      {
        reportStatus: "deletedButReviewed",
      },
      { merge: true }
    )
    .then(() => {
      reviewDoc.set(review);
    });
}