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
function huntRedundantIndexes(json) {
    print("|ns|redundant|covered|");
    print("|-----|-----|-----|");
    json.filter(doc => /getIndexes/.test(doc.command)).forEach(doc => {
        if (!doc.output) {
            // This is a view
            // printjson(doc);
            return;
        }
        var ns = `${doc.commandParameters.db}.${doc.commandParameters.collection}`;
        doc.output.forEach(idx1 => {
            var keys1 = Object.keys(idx1.key);
            var vals1 = Object.values(idx1.key);
            // printjson(keys1);
            for(var i = 0; i < doc.output.length; i++) {
                var idx2 = doc.output[i];
                var keys2 = Object.keys(idx2.key);
                var vals2 = Object.values(idx2.key);
                // printjson(keys2);
                if (isPrefix(keys1, keys2, vals1, vals2)) {
                    // var ns = idx1.ns;
                    var redundant = JSON.stringify(idx1.key);
                    var covered = JSON.stringify(idx2.key);
                    print(`|${ns}|\\${redundant}|\\${covered}|`);
                    break;
                }
            };
        });
    });
};

const fs = require('fs');
function huntRedundantIndexesFromFile(file) {
    let raw = fs.readFileSync(file);
    let json = JSON.parse(raw);
    huntRedundantIndexes(json);
}