const functions = require("firebase-functions");
const admin = require("firebase-admin");

//MARK: - Listeners
exports.addNumberOfPosts = functions.firestore
  .document("posts/{postId}")
  .onCreate((snapshot, context) => {
    const postData = snapshot.data();
    const cid = postData.cid;
    return updateNumberOfPosts(cid, true);
  });

 exports.subtractNumberOfPosts = functions.firestore
    .document("posts/{postId}") 
    .onDelete((snapshot, context) => {
        const postData = snapshot.data();
        const cid = postData.cid;
        return updateNumberOfPosts(cid, false)
    })


//------------------------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
async function updateNumberOfPosts(categoryId, shouldIncrement) {
  const reportDoc = admin.firestore().doc(`/categories/${categoryId}`);

  if (shouldIncrement) {
    return reportDoc.update({
        numberOfPosts: admin.firestore.FieldValue.increment(1)
    });
  } else {
      return reportDoc.update({
          numberOfPosts: admin.firestore.FieldValue.increment(-1)
      });
  }

}