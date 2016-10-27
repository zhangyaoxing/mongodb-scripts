var DAYS_TO_KEEP = 30;
var COLLECTION = "LOG_TRACE_T";
var GAP_TIME_SECS = 1;
var DELETE_BATCH_SIZE = 100;

var secsToKeep = DAYS_TO_KEEP * 3600 * 24;
var now = new Date().getTime();
var hexSecs = (Math.floor(now / 1000) - secsToKeep).toString(16);
var objId = ObjectId(hexSecs + "0000000000000000");

function ttlRemove() {
	var deletePointResult = db[COLLECTION].find({_id {$lte: objId}})
		.sort({_id: 1})
		.skip(DELETE_BATCH_SIZE)
		.limit(1)
		.toArray();
	var deletePoint = null;
	if (deletePointResult.length) {
		var deletePoint = deletePointResult[0];
	} else {
		deletePointResult = db[COLLECTION].find({_id {$lte: objId}})
			.sort({_id: -1})
			.limit(1)
			.toArray();
		if (deletePointResult.length) {
			deletePoint = deletePointResult[0];
		}
	}

	if (deletePoint) {
		db[COLLECTION].remove({_id: {$lte: deletePoint}});
		setTimeout(ttlRemove, GAP_TIME_SECS * 1000);
	}
}

ttlRemove();