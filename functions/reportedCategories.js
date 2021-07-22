const functions = require("firebase-functions");
const admin = require("firebase-admin");

//WARNING: ReportTypes should have the same values like in the Frontend specified!

//MARK: - Listeners
exports.reportedCategories = functions.firestore
  .document("reportedCategories/{categoryId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const categoryId = context.params.categoryId;

    var inappropriateCount = newValue.inappropriateCount;
    var inactiveCount = newValue.inactiveCount;

    const category = newValue.category;
    const numberOfPosts = category.numberOfPosts;
    const creationDate = category.creationDate;

    if (!inappropriateCount) {
      inappropriateCount = 0;
    }

    if (!inactiveCount) {
      inactiveCount = 0;
    }

    var review = {
      category: category,
      inappropriateCount: inappropriateCount,
      inactiveCount: inactiveCount
    };

    //Check if potentially inappropriate category should be reviewed/deleted
    var automaticDeleteInappropriate = checkInappropriateAutomaticDelete(inappropriateCount, numberOfPosts);
    var shouldReviewInappropriate = false;
    if (!automaticDeleteInappropriate) {
      shouldReviewInappropriate = checkInappropriateShouldReview(inappropriateCount);
    } 

    if (automaticDeleteInappropriate || shouldReviewInappropriate) {
      return reviewOrDeletePost(automaticDeleteInappropriate, shouldReviewInappropriate, review, "inappropriate", categoryId);
    }

    //Check if potentially inactive should be reviewed/deleted
    var automaticDeleteInactive = checkInactiveAutomaticDelete(inactiveCount, numberOfPosts, creationDate);
    var shouldReviewInactive = false;
    if (!automaticDeleteInactive) {
        shouldReviewInactive= checkInactiveShouldReview(wrongCategoryCount, numberOfPosts, creationDate);
    }

    if (automaticDeleteInactive || shouldReviewInactive) {
      return reviewOrDeletePost(automaticDeleteInactive, shouldReviewInactive, review, "inactive", categoryId);
    }

  });

//----------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
function checkInappropriateAutomaticDelete(count, numberOfPosts) {
  var automaticDelete = false;
  automaticDelete = count > 1 && numberOfPosts < 4;
  automaticDelete = automaticDelete || (count     > 2 && numberOfPosts < 6);
  return automaticDelete;
}

function checkInappropriateShouldReview(count) {
    return count > 2;
}

function checkInactiveAutomaticDelete(count, numberOfPosts, creationDate) {
  var automaticDelete = false;
  const nowDate = new Date();
  const elapsedTime = (nowDate.getTime() - creationDate.toDate().getTime());
  const daysDifference = Math.floor(elapsedTime/1000/60/60/24);
  functions.logger.log("time difference is: ", daysDifference);

  automaticDelete = count > 1 && daysDifference > 30 && numberOfPosts < 5;
  automaticDelete = automaticDelete || (count > 2 && daysDifference > 60 && numberOfPosts < 10);

  return automaticDelete;
}

function checkInactiveShouldReview(count, numberOfPosts, creationDate) {
  return false; //currently no automatic review
}

function reviewOrDeletePost(automaticDelete, shouldReview, review, reportStatus, categoryId) {
  const reviewDoc = admin.firestore().doc(`/reviewCategories/${categoryId}`);
  const cateogoryDoc = admin.firestore().doc(`/categories/${categoryId}`);
  const reportDoc = admin.firestore().doc(`/reportedCategories/${categoryId}`)

  if (automaticDelete) {
      return reportDoc.delete.then(() => {
          return cateogoryDoc.delete();
      });
  } else if (shouldReview) {
      review.deleted = false;
      review.reportStatus = reportStatus;
      return reviewDoc.set(review);
  }

}