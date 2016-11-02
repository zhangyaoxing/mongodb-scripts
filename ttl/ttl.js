var DAYS_TO_KEEP = 130;
var COLLECTION = "IOC_LSPLocInfo";
var GAP_TIME_SECS = 10;
var DELETE_BATCH_SIZE = 1;

var secsToKeep = DAYS_TO_KEEP * 86400;	// 60m * 60s * 24h = 86400
var now = new Date().getTime();
var hexSecs = (Math.floor(now / 1000) - secsToKeep).toString(16);
var objId = ObjectId(hexSecs + "0000000000000000");

var ttlRemove = function() {
	var deletePoint = null;
	var deletePointResult = db[COLLECTION].find({_id: {$lte: objId}}, {_id: 1})
		.sort({_id: 1})
		.skip(DELETE_BATCH_SIZE)
		.limit(1)
		.toArray();
	if (deletePointResult.length) {
		var deletePoint = deletePointResult[0];
	} else {
		deletePointResult = db[COLLECTION].find({_id: {$lte: objId}}, {_id: 1})
			.sort({_id: -1})
			.limit(1)
			.toArray();
		if (deletePointResult.length) {
			deletePoint = deletePointResult[0];
		}
	}

	if (deletePoint) {
		db[COLLECTION].remove({_id: {$lte: deletePoint}});
		return true;
	}

	return false;
}

while (ttlRemove()) {
	sleep(GAP_TIME_SECS * 1000);
}