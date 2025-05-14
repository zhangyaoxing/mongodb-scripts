function indexInfo(json) {
    var indexes = {};
    json.filter(doc => /getIndexes/.test(doc.command)).filter(doc => {
        return !["local", "admin", "config"].includes(doc.commandParameters.db);
    })
    .forEach(doc => {
        if (!doc.output || doc.output.length == 0) {
            // This is a view or no index. Ignore.
            return;
        }
        var nsobj = {};
        // indexes[doc.output[0].ns] = nsobj;
        ns = `${doc.commandParameters.db}.${doc.commandParameters.collection}`;
        indexes[ns] = nsobj;
        doc.output.forEach(idx => {
            nsobj[idx.name] = {
                _id: JSON.stringify(idx.key),
                key: idx.key,
                indexSize: null
            };
        });
    });
    // printjson(indexes);
    var problemIndexes = [];
    json.filter(doc => /getCollection\(col\)\.stats/.test(doc.command)).forEach(doc => {
        if (doc.error || !doc.output) {
            return;
        }
        var nsobj = indexes[doc.output.ns];
        nsobj = nsobj ? nsobj : {};
        nsobj.dataSize = doc.output.size;
        nsobj.storageSize = doc.output.storageSize;
        for(key in doc.output.indexSizes) {
            // print(doc.output.ns, key);
            if (nsobj[key]) {
                nsobj[key].indexSize = doc.output.indexSizes[key];
                // now you can use both index name and key to search for index info
                nsobj[nsobj[key]._id] = nsobj[key];
            } else {
                problemIndexes.push({
                    ns: doc.output.ns,
                    index: key
                })
            }
        }
    });
    // printjson(indexes);
    return indexes;
}