var typeMapping = [{
	type: Date,
	format: "$date",
	toShell: function(obj) {
		return new Date(obj["$date"]["$numberLong"]);
	},
	toStrict: function(obj) {
		return {
			"$date": {
				"$numberLong": obj.getTime()
			}
		};
	}
}, {
	type: ObjectId,
	format: "$oid",
	toShell: function(obj) {
		
	},
	toStrict: function(obj) {

	}
}, {
	type: NumberLong,
	format: "$numberLong",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: BinDate,
	format: "$binData",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: Timestamp,
	format: "",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: RegExp,
	format: "",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: DBRef,
	format: "",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: MinKey,
	format: "",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}, {
	type: MaxKey,
	format: "",
	toShell: function(obj) {
	},
	toStrict: function(obj) {

	}
}];

function
switch (obj) {
	for (var p in obj) {
		if (p instanceof Object) {
			switch (p);
		} else if (p instanceof Date) {}
	}
}