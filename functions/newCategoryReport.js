const functions = require("firebase-functions");
const admin = require("firebase-admin");

//MARK: - Listeners
exports.newCategoryReport = functions.firestore
  .document("users/{uid}/reportedCategories/{categoryId}")
  .onCreate((snapshot, context) => {
    const reportData = snapshot.data();
    const reportStatus = reportData.reportStatus;
    return createNewReport(reportStatus, snapshot.id);
  });

//------------------------------------------------------------------------------------------------------------------------------------
//MARK: - Methods
async function createNewReport(reportStatus, categoryId) {
  const reportDoc = admin.firestore().doc(`/reportedCategories/${categoryId}`);
  const reportSnapshot = await reportDoc.get();
  const reportData = reportSnapshot.data();
  const countField = reportStatus + "Count";

  //get the most recent category attributes
  const categoryDoc = admin.firestore().doc(`/categories/${categoryId}`);
  const categorySnapshot = await categoryDoc.get();
  const categoryData = categorySnapshot.data();

  if (reportData) {
    if (categoryData[countField]) {
      return reportDoc.update({
        [countField]: admin.firestore.FieldValue.increment(1),
        category: categoryData,
      });
    }
  }

  var newReport = {};
  newReport.category = categoryData;
  newReport[countField] = 1;
  return reportDoc.set(newReport, { merge: true });
}