const functions = require("firebase-functions");
const admin = require("firebase-admin");

//WARNING: ReportTypes should have the same values like in the Frontend specified!

//MARK: - Listeners
exports.reportedPosts = functions.firestore
  .document("reportedPosts/{postId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const postId = context.params.postId;

    var inappropriatePostCount = newValue.inappropriateCount;
    var fakeUserPostCount = newValue.fakeUserCount;
    var wrongCategoryPostCount = newValue.wrongCategoryCount;

    const post = newValue.post;
    const likes = post.likes;
    const rate = post.rate;

    var standardReport = {
      post: post,
      likes: likes,
      rate: rate,
      userInitiated: false,
    };

    //Check if potentially inappropriate post should be passed on
    //If Posts gets reviewed, others aren't checked anymore
    var automaticInappropriate = checkInappropriateAutomaticDelete(inappropriatePostCount, rate, likes);
    var reviewInappropriate = checkInappropriateReview(inappropriatePostCount, rate, likes);

    if (automaticInappropriate || reviewInappropriate) {
      standardReport.count = inappropriatePostCount;
      return passOnReport(automaticInappropriate, reviewInappropriate, standardReport, "inappropriate", postId);
    }

    //Check if potentially wrongCategory post should be passed on
    var automaticWrongCategory = checkWrongCategoryAutomaticDelete(wrongCategoryPostCount, rate, likes);
    var reviewWrongCategory = checkWrongCategoryReview(wrongCategoryPostCount, rate, likes);

    if (automaticWrongCategory || reviewWrongCategory) {
      standardReport.count = wrongCategoryPostCount;
      return passOnReport(automaticWrongCategory, reviewWrongCategory, standardReport, "wrongCategory", postId);
    }

    //Check if potentially fakeUser post should be passed on
    var automaticFakeUser = checkFakeUserAutomaticDelete(fakeUserPostCount, rate, likes);
    var reviewFakeUser = checkFakeUserReview(fakeUserPostCount, rate, likes);

    if (automaticFakeUser || reviewFakeUser) {
      standardReport.count = fakeUserPostCount;
      return passOnReport(automaticFakeUser, reviewFakeUser, standardReport, "fakeUser", postId);
    }

  });

//----------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
//rate = 0.5 is important figure because that is the default rate when the post gets created
function checkInappropriateAutomaticDelete(count, rate, likes) {
  if (!count) {
    return false;
  }
  var automaticDelete = false;
  automaticDelete = count > 2 && rate == 0.5 && likes == 0; //NEED Extra Review
  automaticDelete = automaticDelete || (count > 1 && rate < 0.35 && likes < 10); //NO Extra Review
  automaticDelete =
    automaticDelete || (count > 2 && rate < 0.35 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkInappropriateReview(count, rate, likes) {
  if (!count) {
    return false;
  }
  var review = false;
  review = (count > 2 && rate >= 0.35); //Extra and General Review
  return review;
}

function checkWrongCategoryAutomaticDelete(count, rate, likes) {
  if (!count) {
    return false;
  }
  var automaticDelete = false;
  automaticDelete = count > 3 && rate == 0.5 && likes == 0; //NEED Extra Review
  automaticDelete = automaticDelete || (count > 1 && rate < 0.25 && likes < 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 2 && rate < 0.3 && likes >= 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 4 && rate < 0.4 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkWrongCategoryReview(count, rate, likes) {
  if (!count) {
    return false;
  }
  var review = false;
  review = count > 3 && rate == 0.5 && likes == 0; //Extra Review
  return review;
}

function checkFakeUserAutomaticDelete(count, rate, likes) {
  if (!count) {
    return false;
  }
  var automaticDelete = false;
  automaticDelete = count > 1 && rate < 0.2 && likes < 10; //NO Extra Review
  automaticDelete = automaticDelete || (count > 3 && rate < 0.3 && likes >= 10); //NO Extra Review
  automaticDelete = automaticDelete || (count > 4 && rate < 0.4 && likes >= 10); //NO Extra Review
  return automaticDelete;
}

function checkFakeUserReview(count, rate, likes) {
  if (!count) {
    return false;
  }
  var review = false;
  review = count > 4 && rate >= 0.4 && likes >= 10; //General Review
  return review;
}

function passOnReport(automaticDelete, review, report, reportType, postId) {
  const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
  const postDoc = admin.firestore().doc(`/posts/${postId}`);


  //Todo: if automatically deleted, probably should also be deleted from reportedPosts
  if (automaticDelete && review) {
    report.reportType = `${reportType}`;
    report.deleted = true;
    return reviewDoc.set(report).then(() => {
      return postDoc.set({
        reportStatus: 'reviewRequested'
      }, {merge: true});
    });
  } else if (automaticDelete) {
    return postDoc.set({
        reportStatus: reportType
      }, {merge: true});
  } else if (review) {
    report.reportType = `${reportType}`;
    report.deleted = false;
    return reviewDoc.set(report); //not changing the reportStatus of the post yet, shouldn't be deleted automatically
  }

}
