var DAYS_TO_KEEP = 136;
var COLLECTION = "IOC_LSPLocInfo";
var GAP_TIME_SECS = 1;
var DELETE_BATCH_SIZE = 100;

var secsToKeep = DAYS_TO_KEEP * 86400;	// 60m * 60s * 24h = 86400
var now = new Date().getTime();
var hexSecs = (Math.floor(now / 1000) - secsToKeep).toString(16);
var objId = ObjectId(hexSecs + "0000000000000000");

var ttlRemove = function() {
	var deletePoint = null;
	// find the batch of documents to delete
	var deletePointResult = db[COLLECTION].find({_id: {$lte: objId}})
		.sort({_id: 1})
		.limit(DELETE_BATCH_SIZE)
		.toArray();
	if (deletePointResult.length) {
		var deletePoint = deletePointResult[deletePointResult.length - 1]._id;
	}

	if (deletePoint) {
		for (var i = deletePointResult.length - 1; i >= 0; i--) {
			printjsononeline(deletePointResult[i]);
		}
		// print(deletePoint.getTimestamp());
		db[COLLECTION].remove({_id: {$lt: deletePoint}});
		return true;
	}

	return false;
}

while (ttlRemove()) {
	sleep(GAP_TIME_SECS * 1000);
}