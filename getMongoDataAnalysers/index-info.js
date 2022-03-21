function indexInfo(json) {
    var indexes = {};
    json.filter(doc => /getIndexes/.test(doc.command)).forEach(doc => {
        if (!doc.output || doc.output.length == 0) {
            // This is a view or no index. Ignore.
            return;
        }
        var ns = {};
        indexes[doc.output[0].ns] = ns;
        doc.output.forEach(idx => {
            ns[idx.name] = {
                _id: JSON.stringify(idx.key),
                key: idx.key,
                indexSize: null
            };
        });
    });
    // printjson(indexes);
    json.filter(doc => /getCollection\(col\)\.stats/.test(doc.command)).forEach(doc => {
        if (doc.error || !doc.output) {
            return;
        }
        var ns = indexes[doc.output.ns];
        ns = ns ? ns : {};
        ns.dataSize = doc.output.size;
        ns.storageSize = doc.output.storageSize;
        for(key in doc.output.indexSizes) {
            ns[key].indexSize = doc.output.indexSizes[key];
            // now you can use both index name and key to search for index info
            ns[ns[key]._id] = ns[key];
        }
    });
    // printjson(indexes);
    return indexes;
}