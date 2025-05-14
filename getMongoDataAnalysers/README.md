# GetMongoData Analysers
## Introduction
The scripts here is used to analyse the [getMongoData.js](https://github.com/mongodb/support-tools/tree/master/getMongoData) output to find:
- Low utilization indexes: `huntLowUtilIndexes`
- Redundant indexes: `huntRedundantIndexes`

## Compatibility
The script is designed to run with `mongosh`. 
Legacy mongo shell cannot load JSON data from a file, you'll need to read it yourself, then call the functions.

## Usage
Before you start, run `mongosh` without connecting any database:
```bash
cd getMongoDataAnalysers
mongosh --nodb
```
### Find Redundant Indexes
```javascript
load("hunt-redundant-indexes.js");
huntRedundantIndexesFromFile("<getMongoData output>");
```
If you are using legacy mongo shell, load the json file by yourself, then call:
```javascript
huntRedundantIndexes(json)
```

### Find Low Utilization Indexes
```javascript
load("hunt-low-uitil-indexes.js");
huntLowUtilIndexesFromFile("<getMongoData output>");
```
If you are using legacy mongo shell, load the json file by yourself, then call:
```javascript
huntLowUtilIndexes(json)
```

## Output
The output is in markdown format. Use any tool that can preview markdown to view the result.