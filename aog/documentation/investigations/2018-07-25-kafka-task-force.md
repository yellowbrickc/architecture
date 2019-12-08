# Kafka Task Force

## What is the problem?

Problems occurred where consumers which were connected to Kafka seemed to stop processing of new messages after a while. Feeling was that this could especially be observed after weekends, meaning after a while of relatively low volume.

We tried to investigate this issue before, but without any luck of finding the error or anything which could explain this behavior.

Therefore we switched to a new Kafka consumer client with the hope that this resolves the issue. However, after a while reports came in that messages were still not received.

## Conclusion after 2 days

- We did not find any software issue / bug which indicates such a behavior we have been seeing
- Configuration of services and Kafka do not indicate anything either
- The test setups both on the local machines as well as in the integration environment work as expected, therefore we have **not been able to reproduce the issue**
- Scanning the logs makes us think that the problem has actually been solved with the new consumer implementation (however, we cannot say for sure **why** and cannot guarantee this)
- The latest consumer version should be rolled out to **all environments** as soon as possible in order to reduce noise and actually be able to see the issue again without falling for false positives

#### Possible ToDos if the problem is encountered again

- Check -1 committed offsets
- "missing handlers for Correlation ID" error message analysis
- More in-depth analysis on how offsets are committed
- Set NBS consumer verbosity to trace (Friday)

Our feeling is that "Check -1 committed offsets" is the task from the list which will most likely get us closer to a solution in case the problem occurs again. For more details on this topic see ["-1 Offsets"](#1-offsets)

## What has been done

### Create local test environment

- Full kafka cluster as it is deployed in the various environments - [GitLab link](https://git.sub.rocks/shared/paas/eventbus-local)
- NodeJS publisher using the usual kafka-publisher package with a configurable interval and topic to publish messages to. Event validation was deactivated. [GitLab link](https://git.sub.rocks/new-business/test-publisher-1)
- NodeJS consumer using the usual kafka-consumer package with a configurable consumer group . Event validation was deactivated. [GitLab link](https://git.sub.rocks/new-business/test-consumer-1)
- compose setup for node publisher & consumer [GitLab link](https://git.sub.rocks/pschramm/kafka-node-setup)
- Scala consumer with compose. No event validation. [GitLab link](https://git.sub.rocks/rmanfrahs/kafka-consumer.git)

### "Group is now empty" warning messages

We noticed that there are many warnings in the Kafka broker logs about consumers groups being empty after rebalancing has finished but consumers seem to be failing.
However we found that this is connected to the forceReconnect method we currently have implemented as there is a delay of 10s before a new consumer will join the group. Therefore that warning is actually true and expected and does not point to any error.

### Rebalancing

We tried to enforce a rebalancing with the local setup by

- Killing Kafka nodes
	- Also specifically killing the leader
- Scaling consumers
- Killing consumers
- Adding partitions via kafka-manager ([see Docker Hub](https://hub.docker.com/r/sheepkiller/kafka-manager/))

Each of these consistently produced a rebalance, however the handling of this is clean on the consumer side and no messages were lost. Consumers successfully reconnected, leader assignment happened as expected and everything worked just fine.

### idleConnection / connections.max.idle.ms

- [Broker side configuration](http://kafka.apache.org/documentation/) (connections.max.idle.ms)
- [Client side configuration](https://github.com/SOHU-Co/kafka-node#kafkaclient) (idleConnection)

We thought that this setting might lead to consumers getting disconnected by the broker due to becoming idle.
However at the same time we are using the [fetchMaxWaitMs](https://github.com/SOHU-Co/kafka-node#highlevelconsumer) setting which triggers the consumer to actively try to poll new messages in case the broker has not sent anything for the specified amount of time. Using this poll interval effectively marks the consumer as "not idle", therefore the idleConnection / connections.max.idle.ms settings has no effect (see [Kafka documentation at max.poll.interval.ms](http://kafka.apache.org/documentation/)).
> This places an upper bound on the amount of time that the consumer can be idle before fetching more records.

Side note: The consumerGroup implementation in the kafka-node package inherits from the highLevelConsumer (which basically was the predecessor of consumerGroups and share a lot of functionality).

### Integration test setup

We create a test setup in integration with 5 producers, each producing messages to dedicated topics with dedicated consumerGroups. Every consumerGroup has one consumer connected. Additionally there is one more consumer connected to all groups with specific consumerGroups.

| Publisher        | Interval | Topic | Consumer        |
|------------------|----------|-------|-----------------|
| test-publisher-1 | 1 min    | testa | test-consumer-1 |
| test-publisher-2 | 7 min    | testb | test-consumer-2 |
| test-publisher-3 | 15 min   | testc | test-consumer-3 |
| test-publisher-4 | 90 min   | testd | test-consumer-4 |
| test-publisher-5 | 360 min  | teste | test-consumer-5 |
|                  |          | all   | test-consumer-6 |

Results: All working as expected, no issues found.

### Comparison Scala & node.js configs

[Apache Java client reference documentation](http://kafka.apache.org/documentation.html#newconsumerconfigs)

The configuration values indicated in the documentation only describe the reference client. There might be different settings in other clients and different implementations. This is the case for the node.js client as well.
We tried to (and were able to) match every important value from the documentation and compare them between Scala and node.js. The differences are listed below:

|                         | Scala    | Node     | Kafka Default |
|-------------------------|----------|----------|---------------|
| autoCommit              | false    | true     | true          |
| connections.max.idle.ms | 540000   | 30000    | 540000        |
| fetch.max.bytes         | 52428800 | 1048576  | 52428800      |
| fetch.max.wait.ms       | 500      | 200-2000 | 500           |
| heartbeat.interval.ms   | 3000     | 10000    | 3000          |
| max.poll.records        | 10       | not set  | 500           |
| request.timeout.ms      | 305000   | 30000    | 305000        |

We also played around with the values and could achieve different behavior - all of which was expected according to the settings though. Therefore we think that the configuration of the node.js client is good and ok so far and not responsible for the errors we are seeing.

### Implement consumer group lag metrics

[PAAS-376](https://jira.cgn.cleverbridge.com/browse/PAAS-376) has been implemented and is visible in Grafana. [The dashboard is visible here](https://metrics.sub.rocks/d/000000022/eventbus?refresh=30s&panelId=53&orgId=1&tab=general).

[List of available metrics](https://github.com/danielqsj/kafka_exporter#metrics)

When bringing down the consumers in NBS we could successfully produce a lag which was shown in the dashboard. So far no other lag despite short term lags due to fetching intervals (~2 sec) were observed.

### Deep implementation analysis

We tried to have a look at how the packages actually implement Kafka, how they behave, how offsets are committed and errors are handled. As this was a big task we certainly did not complete this in every detail, but there was no obvious error or bad implementation which could lead to such a behavior. (Which does not mean that the code was quite bad here and there ;-)).

### -1 offsets

Any partition of a consumer group which is freshly set up will have an offset of -1. In the newly created dashboards you can see partitions which are still in this status: [The dashboard](https://metrics.sub.rocks/d/000000022/eventbus?refresh=30s&panelId=53&orgId=1&tab=general) - ConsumerGroup Lag -> see current offset.

A quick test with the domain event consumer in S&C early environment showed that once the consumer was restarted, most of the offsets were set correctly. As a comparison:

```
{consumergroup="payment-connect_payment_client-hub_logging",partition="0",topic="payment-connect_payment"} 420
 {consumergroup="payment-connect_payment_client-hub_logging",partition="1",topic="payment-connect_payment"} -1
 {consumergroup="payment-connect_payment_client-hub_logging",partition="2",topic="payment-connect_payment"} -1
 {consumergroup="payment-connect_payment_client-hub_logging",partition="3",topic="payment-connect_payment"} 332
 {consumergroup="payment-connect_payment_client-hub_logging",partition="4",topic="payment-connect_payment"} -1
 {consumergroup="payment-connect_payment_client-hub_logging",partition="5",topic="payment-connect_payment"} 326
 {consumergroup="payment-connect_payment_client-hub_logging",partition="6",topic="payment-connect_payment"} -1
 {consumergroup="payment-connect_payment_client-hub_logging",partition="7",topic="payment-connect_payment"} -1
```

```
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="0",topic="payment-connect_payment"} 420
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="1",topic="payment-connect_payment"} 356
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="2",topic="payment-connect_payment"} 369
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="3",topic="payment-connect_payment"} 332
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="4",topic="payment-connect_payment"} 410
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="5",topic="payment-connect_payment"} 326
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="6",topic="payment-connect_payment"} 387
 {consumergroup="payment-connect_payment_existing-business_contract-center",partition="7",topic="payment-connect_payment"} 340

```

Meaning: Partition index 1 of the consumer group `payment-connect_payment_client-hub_logging` has an offset of -1 whereas `payment-connect_payment_existing-business_contract-center` has 356 - which client hub should also have!

It seems that for partitions where no offset has been committed at the start of the service, the polling of Kafka messages does not seem to live on. Therefore messages on these partitions won't be fetched. It might also be that committed offsets get reset to -1 sporadically, see [this StackOverflow article](https://stackoverflow.com/questions/51258938/kafka-consumer-group-offset-goes-down-to-1).
How this is happening and why we cannot tell at the moment as we were running out of time.

**However it seems like this does only happen with the old version of the consumer.**

> Note: -1 of a committed offset usually resembles the "latest" offset, -2 resembles "earliest".

> Additional note: This was discovered quite late in the investigation, therefore we did not have all the time needed to figure out how these offsets were introduced and why processing stops.

### Check logs of 13.07.-18.07.

Despite reports of the same problem occurring again with the new consumer version on the indicated dates, we were **not able** to find anything in the integration environment logs which indicates such a behavior (new business consumer).

Talking to e.g. S&C we figured out that some services, i.e. thank you page relevant services, are not deployed to the early environment with the latest version of the consumer. Therefore e.g. the signup might have possibly failed there.

Again, with **new consumer versions** no issues were observed.

## Other findings

### fluentd lag

We noticed that there is a severe lag between when log output is produced and visible in the command line output vs. when it becomes visible in logs.sub.rocks. At 10:19 the lag was around 55 minutes.

### ConsumerGroup Pause/Resume

There was an advise in the GitHub issues of the project that when messages are being handled you should set the ConsumerGroup to pause, make sure that the message(s) are handled correctly and afterwards resume consumption. This should ensure that there are no race conditions in parallel message handling.

See [GitHub for details](https://github.com/SOHU-Co/kafka-node/issues/1031)

### Long polling

> fetch.max.wait.ms vs. max.poll.interval.ms

`fetch.max.wait.ms`

> The maximum amount of time the server will block before answering the fetch request if there isn't sufficient data to immediately satisfy the requirement given by fetch.min.bytes.

`max.poll.interval.ms`

> The maximum delay between invocations of poll() when using consumer group management. This places an upper bound on the amount of time that the consumer can be idle before fetching more records. If poll() is not called before expiration of this timeout, then the consumer is considered failed and the group will rebalance in order to reassign the partitions to another member.

The node consumer works in a way that a long polling request to the broker is **always** present but `fetch.max.wait.ms` describes for how long the request is kept open before any data received is being processed. A new request will be re-established right away though, there is no moment where no long polling is happening.

This seems to be different from what the Scala consumer does, as it also seems to use the `max.poll.interval.ms` for re-creating polling requests - which the node consumer does not use.

### Kafka retention

Currently the minimal retention is set to 72 hours. This should be increased to one week.