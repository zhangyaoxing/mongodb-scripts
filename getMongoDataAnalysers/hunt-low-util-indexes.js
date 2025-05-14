load("index-info.js");

function huntLowUtilIndexes(json) {
    print("|ns|index|accesses/hour|size(MB)|");
    print("|-----|-----|-----|-----|");
    var indexes = indexInfo(json);
    var problemIndexes = [];
    // Views don't have output
    json.filter(doc => /\$indexStats/.test(doc.command) && doc.output && doc.output.ok == 1).map(doc => {
        return {
            now: new Date(doc.ts.start["$date"]),
            ns: doc.output.cursor.ns,
            stats: doc.output.cursor.firstBatch.map(doc => {
                return {
                    key: doc.key,
                    since: new Date(doc.stats[0].since),
                    accesses: parseInt(doc.stats[0].accesses["$numberLong"], 10)
                };
            })
        };
    }).forEach(doc => {
        var ns = doc.ns;
        var now = doc.now;
        doc.stats.forEach(stat => {
            var durationHours = (now - stat.since) / 1000.0 / 3600.0;
            var accPerHour = stat.accesses / durationHours;
            var key = JSON.stringify(stat.key)
            if (indexes[ns][key]) {
                print(`|${ns}|\\${key}|${accPerHour}|${indexes[ns][key].indexSize}|`);
            } else {
                problemIndexes.push({
                    ns: ns,
                    index: key
                });
            }
        });
    });
    // print(problemIndexes);
};

const fs = require('fs');
function huntLowUtilIndexesFromFile(file) {
    let raw = fs.readFileSync(file);
    let json = JSON.parse(raw);
    huntLowUtilIndexes(json);
}