# Duet Data Design

## Tech
ElasticSearch

### Mapping
JSON-like

User Index Mapping (changes rarely, query every time)
```
"uuid": { "type": "string" },
"properties" : {
  "campus": { "type": "keyword" },
  "avg_response_time": { "type": "float" },
  "last_login": { "type": "something like a datetime" }
}
"judgements": {
  "positive": {
  
  },
  "negative" : {
    # Something adj-list like, with versioning (how many times this has appeared; display negative rated once before negative rated twice
  }
  # Assume neutral if uuid not rated
}
```

Music Index Mapping (changes often, query most every time)
```
"uuid": { "type": "string" },
"Spotify": {
  "recent_listening_distribution" : { "type": "help here" }
}
```
src: https://www.hellointerview.com/learn/system-design/deep-dives/elasticsearch 
* The mapping is crucial because it tells Elasticsearch how to interpret the data you're storing. 
* Mappings also have some important implications on the performance of your cluster: if you include a lot of fields in your mapping that aren't actually used in search, this increases the memory overhead of each index. This can lead to performance issues and increased costs. Say you have a User object with 10 fields, but you only allow searching by 2 of them. If you map the entire object, you're wasting memory on the 8 fields that you're not using. This is notable because a lot of the control that you will exert over query performance depends on adjustments to the mapping and various cluster parameters. We'll touch on that later.
* If reviews are infrequently updated and frequently queried, it may be more efficient to nest them within the book documents. 

### Query

```
// GET /users/_search
{
  "sort": [
    { "avg_response_time": "desc" }
  ],
  "query": {
    "bool": {
      "must": [
        { "match": { "campus": "UW" } }
        # Not yet in the user's rated list
      ]
    }
  }
}
```
Query notes
* From/Size Pagination is enough; we don't expect a single user to require deep pagination (10k swipes in one session)
* The ideal queries are ones that can be answered without ever touching the source documents, sometimes by pulling the relevant data into the index via included fields.
