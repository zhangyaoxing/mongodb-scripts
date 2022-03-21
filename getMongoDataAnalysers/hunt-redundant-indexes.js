load("/Users/yaoxingzhang/Downloads/logs/Walmart/Get_mongo_date_0926/sango-getMongoData-output.json");

function isPrefix(keys1, keys2, vals1, vals2) {
    if (keys1.length < keys2.length) {
        var isPrefix = true;
        // Only if keys1.length < keys2.length is it possible that keys1 is previs of keys2
        for (var i = 0; i < keys1.length; i++) {
            if (keys1[i] != keys2[i] || vals1[i] != vals2[i]) {
                isPrefix = false;
                break;
            }
        }
        return isPrefix;
    }
};
(function() {
    print("|ns|redundant|covered|");
    print("|-----|-----|-----|");
    json.filter(doc => /getIndexes/.test(doc.command)).map(doc => doc.output).forEach(doc => {
        if (!doc) {
            // This is a view
            // printjson(doc);
            return;
        }
        doc.forEach(idx1 => {
            var keys1 = Object.keys(idx1.key);
            var vals1 = Object.values(idx1.key);
            // printjson(keys1);
            for(var i = 0; i < doc.length; i++) {
                var idx2 = doc[i];
                var keys2 = Object.keys(idx2.key);
                var vals2 = Object.values(idx2.key);
                // printjson(keys2);
                if (isPrefix(keys1, keys2, vals1, vals2)) {
                    var ns = idx1.ns;
                    var redundant = JSON.stringify(idx1.key);
                    var covered = JSON.stringify(idx2.key);
                    print(`|${ns}|${redundant}|${covered}|`);
                    
                    break;
                }
            };
        });
    });
})();
