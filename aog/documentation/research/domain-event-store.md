# Research domain event store

## Requirements

- high available (at least for writing)
- store for ever, data loss would be fatal => backup / rollback strategy
- fast complex queries including pagination
    - by datetime
    - by query terms
    - by count, limit
- sorting by creation date ASC

## AWS DynamoDB

### Pro

- could be used asap, as it is in use already (and is separated per system by concept)

### Contra

- pagination is limited to 1MB
- beside that it would be possible to create a GSI to limit the result set by dedicated filter (like eventType, entity) query by datetime is nearly impossible / does not make sense to do it with dynamoDB (see good explaining post from alienangel2: https://www.reddit.com/r/aws/comments/6ojuuj/dynamodb_design_question)
- as it is a AWS own solution, the community is not very broad

### Conclusion

- **This can only be a possible solution for short term**
- effort minimal

## AWS RDS

### Pro

- as fare as I know good to go - it fulfills above requirements
- very common in the community (lots of clients)
- already in use by runtime environment

### Contra

- needs a running Cluster per system and environment? => 9 systems, 3 environments => 27 cluster a 3 nodes => 81 EC2 instances => seems like a lot of overhead and costs
- counting needs to be done by separate queries

### Open Question

- Could we imagine to separate systems within the same cluster by concept (e.g. each cluster uses an own DB) taking into account all the disadvantages?

### Conclusion

- possible solution, but does not feel right
- effort medium

## AWS ElasticSearch

> see some helpful query examples: https://dzone.com/articles/23-useful-elasticsearch-example-queries

### Pro

- very feature rich query possibilities (covers above easily)
- additionally something features like fuzzy-, wildcard-, regex-search, drill down, autosuggestion
- could be very helpful in other use-case as well (imagine our list pages with sorting, pagination, (fuzzy) search, grouping, counts in group, drill down by applying filter, ...)
- very common in the community (lots of clients)
- (fully) mamaged by AWS including 16 days snaphsots retention und recovery from that

### Contra

- there is a learning curve for the query syntax
- same as AWS RDS (Cluster)

### Conclusion

- possible solution which would help for other business requirements as well
- effort medium to high
