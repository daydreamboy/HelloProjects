
## Optimizations

* Extract big data into another table, e.g. spilit `picture` into `pictureThumbnail` field and `Employee2Picture` entity
* use `batchSize` accordingly
* NSPredicate use more efficient format (bool comparison is more faster than string comparison), e.g. "(active == YES) AND (name CONTAINS[cd] %@)" is efficient than "(name CONTAINS[cd] %@) AND (active == YES)"
* use 'count objects' instead of 'get all objects', e.g. NSExpresson, countForFetchRequest:

