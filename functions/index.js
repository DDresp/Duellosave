const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

//User is only allowed to report once and only one reportType!
//Thus, this function only listens to "onCreate"
exports.onReport = functions.firestore
  .document("users/{uid}/reportedPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const uid = context.params.uid;
    const reportData = snapshot.data();
    const reportType = reportData.report;
    return createNewReport(reportType, uid, snapshot.id);
  });

exports.onReportedPostsUpdate = functions.firestore
  .document("reportedPosts/{postId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const postId = context.params.postId;

    const reviewDoc = admin.firestore().doc(`/reviewPosts/${postId}`);
    const automaticDoc = admin.firestore().doc(`/automaticPosts/${postId}`);

    var inappropriatePostCount = newValue.inappropriateCount;
    var fakeUserPostCount = newValue.fakeUserCount;
    var wrongCategoryPostCount = newValue.wrongCategoryCount;

    const post = newValue.post
    const likes = post.likes;
    const rate = post.rate;

    var standardReport = { post: post, likes: likes, rate: rate, userInitiated: false };

    if (!inappropriatePostCount) {
      inappropriatePostCount = 0;
    }

    if (!fakeUserPostCount) {
      fakeUserPostCount = 0;
    }

    if (!wrongCategoryPostCount) {
      wrongCategoryPostCount = 0;
    }

    //Status can be "currently reviewed" or "softdeleted" 
    //review can useriniated or systeminiated 

    //rate = 0.5 is important figure because that is the default rate when the post gets created 

    var automaticInappropriate = false;
    automaticInappropriate = (inappropriatePostCount > 3 && rate <= 0.5 && likes < 10); //Before Competition Starts: rate = 0.5
    automaticInappropriate = (automaticInappropriate || (inappropriatePostCount > 1 && rate < 0.4 && likes < 10));
    automaticInappropriate = (automaticInappropriate || (inappropriatePostCount > 2 && rate < 0.4 && likes >= 10));

    var reviewInappropriate = false;
    reviewInappropriate = (inappropriatePostCount > 3 && rate <= 0.5 && likes < 10);
    reviewInappropriate = (reviewInappropriate || (inappropriatePostCount > 5 && likes < 10));
    reviewInappropriate = (reviewInappropriate || (inappropriatePostCount > 2 && rate >= 0.4 && likes >= 10));

    if (automaticInappropriate && reviewInappropriate) {
      //Developing
      standardReport.report = "inappropriate review and automatic delete";
      standardReport.reportCount = inappropriatePostCount;
      return reviewDoc.set(standardReport);
    } else if (automaticInappropriate) {
      standardReport.report = "inappropriate automatic delete";
      standardReport.reportCount = inappropriatePostCount;
      return automaticDoc.set(standardReport);
    } else if (reviewInappropriate) {
      standardReport.report = "inappropriate review";
      standardReport.reportCount = inappropriatePostCount;
      return reviewDoc.set(standardReport);
    }


    // automatically and put for review!!! could be possible too

  //automatically if post got reported more than 1 time and has less than 10 likes


  // and a rate of less than 0.5
  //automatically if post got reported more than 2 times and has more equal to 10 likes 
  // and a rate of less than 0.4

  //for review  if post got reported more than two times and has more equal to 10 likes
  // and a rate of more equal than 0.4


  // (if fakeUser)
  //automatically if post got reported more than 5 times and a rate of less than 0.4

  //for review if post got reported more than 5 times and a rate of more equal than 0.4


  // (if wrongCategory)
  //automatically if post got reported more than 1 time and a rate of less than 0.3
  //automatically if post got reported more than 2 times and a rate of less than 0.35
  //automatically if post got reported more than 4 times and a rate of less than 0.4
  //automatically if post got reported more than 8 times and a rate of less than 0.5

  //change post status without review, if posts don't create significant value in the network anyway


  });

async function createNewReport(reportType, uid, postId) {
  const reportDoc = admin.firestore().doc(`/reportedPosts/${postId}`);
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();
  const countField = reportType + "Count";

  const postDoc = admin.firestore().doc(`/posts/${postId}`);
  const postSnapshot = await postDoc.get();
  const postData = postSnapshot.data();

  if (reportData) {
    if(reportData[countField]) {
      return reportDoc.update({
        [countField]: admin.firestore.FieldValue.increment(1),
        post: postData
      });
    }
  }

  var newReport = {};
  newReport.post = postData;
  newReport[countField] = 1;
  return reportDoc.set(newReport, { merge: true });

}