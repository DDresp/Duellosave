const functions = require("firebase-functions");
const admin = require("firebase-admin");

//WARNING: ReportTypes should have the same values like in the Frontend specified!

//MARK: - Listeners
exports.reportedPosts = functions.firestore
  .document("reportedPosts/{postId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const postId = context.params.postId;

    var inappropriateCount = newValue.inappropriateCount;
    var fakeUserCount = newValue.fakeUserCount;
    var wrongCategoryCount = newValue.wrongCategoryCount;

    const post = newValue.post;
    const likes = post.likes;
    const rate = post.rate;

    if (!inappropriateCount) {
      inappropriateCount = 0;
    }

    if (!fakeUserCount) {
      fakeUserCount = 0;
    }

    if (!wrongCategoryCount) {
      wrongCategoryCount = 0;
    }

    var review = {
      post: post,
      inappropriateCount: inappropriateCount,
      fakeUserCount: fakeUserCount,
      wrongCategoryCount: wrongCategoryCount,
      userInitiatedReview: false
    };

    //Check if potentially inappropriate post should be reviewed/deleted
    var automaticDeleteInappropriate = checkInappropriateAutomaticDelete(inappropriateCount, rate, likes);
    var shouldReviewInappropriate = checkInappropriateShouldReview(inappropriateCount, rate, likes);

    if (automaticDeleteInappropriate || shouldReviewInappropriate) {
      return reviewOrDeletePost(automaticDeleteInappropriate, shouldReviewInappropriate, review, "inappropriate", postId);
    }

    //Check if potentially wrongCategory post should be reviewed/deleted
    var automaticDeleteWrongCategory = checkWrongCategoryAutomaticDelete(wrongCategoryCount, rate, likes);
    var shouldReviewWrongCategory = checkWrongCategoryShouldReview(wrongCategoryCount, rate, likes);

    if (automaticDeleteWrongCategory || shouldReviewWrongCategory) {
      return reviewOrDeletePost(automaticDeleteWrongCategory, shouldReviewWrongCategory, review, "wrongCategory", postId);
    }

    //Check if potentially fakeUser post should be reviewed/deleted
    var automaticDeleteFakeUser = checkFakeUserAutomaticDelete(fakeUserCount, rate, likes);
    var shouldReviewFakeUser = checkFakeUserShouldReview(fakeUserCount, rate, likes);

    if (automaticDeleteFakeUser || shouldReviewFakeUser) {
      return reviewOrDeletePost(automaticDeleteFakeUser, shouldReviewFakeUser, review, "fakeUser", postId);
    }

  });

//----------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
//rate == 0.5 and likes == 0 imply that the post got created but hasnt been rated yet (perhaps the post's category new)
function checkInappropriateAutomaticDelete(count, rate, likes) {
  var automaticDelete = false;
  automaticDelete = count > 1 && rate == 0.5 && likes == 0; //NEED Extra Review
  automaticDelete = automaticDelete || (count > 1 && rate < 0.35 && likes < 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 2 && rate < 0.35 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkInappropriateShouldReview(count, rate, likes) {
  var review = false;
  review = count > 1 && rate == 0.5 && likes == 0;
  review = review || (count > 2 && rate >= 0.35); //Extra and General Review
  return review;
}

function checkWrongCategoryAutomaticDelete(count, rate, likes) {
  var automaticDelete = false;
  automaticDelete = count > 2 && rate == 0.5 && likes == 0; //No Extra Review
  automaticDelete = automaticDelete || (count > 1 && rate < 0.25 && likes < 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 2 && rate < 0.3 && likes >= 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 4 && rate < 0.35 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkWrongCategoryShouldReview(count, rate, likes) {
  return false; //currently no automatic review
}

function checkFakeUserAutomaticDelete(count, rate, likes) {
  var automaticDelete = false;
  automaticDelete = count > 1 && rate < 0.2 && likes < 10; //NO Extra Review
  automaticDelete = automaticDelete || (count > 2 && rate < 0.3 && likes >= 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 4 && rate < 0.4 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkFakeUserShouldReview(count, rate, likes) {
  var review = false;
  review = count > 4 && rate >= 0.4 && likes >= 10; //General Review
  return review;
}

function reviewOrDeletePost(automaticDelete, shouldReview, review, reportStatus, postId) {
  const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
  const postDoc = admin.firestore().doc(`/posts/${postId}`);
  const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`)

  if (automaticDelete && shouldReview) {
    review.deleted = true;
    return reviewDoc.set(review).then(() => {
      return postDoc.set({
        reportStatus: 'deletedButReviewed'
      }, {merge: true});
    }).then(() => {
      return reportDoc.delete();
    });
  } else if (automaticDelete) {
    return postDoc.set({
        reportStatus: reportStatus
      }, {merge: true}).then(() => {
        return reportDoc.delete();
      });
  } else if (shouldReview) {
    review.deleted = false;
    return reviewDoc.set(review); //not changing the reportStatus of the post yet, shouldn't be deleted automatically
  }

}
