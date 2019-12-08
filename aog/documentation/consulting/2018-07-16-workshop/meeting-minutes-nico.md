# TW - meeting minutes	
	
## CD

> Continuous delivery is a journey. It never stops. :-)

- have configuration versioned
- after passing system-e2e and platform-e2e directly deploy to next environment
- in case some error happens at early / production, digg into it and find out how to improve your pipeline to avoid that in future
- use feature flags to help to rollout (that is for developers to help to go fast)
- business flags help to enable features from business perspective (A/B testing some features)
- let Product Owner "push the button" :-)
- Recommendation: the team should own the process, the PaaS Team should only support with tooling

## signup flow

- think about to do critical things synchronously
- what about consuming domain events during the platform-e2e tests to make sure that during the process all domain events gets published
- platform-e2e: as few and as simple as possible
- synthetic monitoring: 
	- run platform-e2e every 'minute'
	- add user-agent to filter...
	- should may run on the environment itself
- it is absolutely ok to have this kind of redirect mechanism 
- it is ok to rely on this event driven flow (at the bottom), but we need to make sure that this is tested very well and also think about business rules to handle failure cases

### correlationId

- Scala: zipkin

## API discussion

> REST vs. GraphQL: https://blog.goodapi.co/rest-vs-graphql-a-critical-review-5f77392658e7
> How to design GraphQL properly: https://gist.github.com/swalkinshaw/3a33e2d292b60e68fcebe12b62bbb3e2

- as few (-> just one call is simple) calls as possible, which keeps us flexible in the long run
- best would be to have one call to fetch all data the client needs to display and have one call to create the subscription
- try to respond on that call as fast as possible (all checks which needs to be there from legal / business perspective)
- make it easy for the first run, may the backend processing speed is fast enough to wait for an "answer" from other verticals
- try to do everything asynchronously which needs to be done in the background
- send notifications about success or failure
- give may client possibility to pull success / failure
- eat your own dogfood: should we exchange the current hosted pages approach to consume our own API? -> YES
- support the client with some SDK's
- document well, may use some interface/experience designer

- Idea: give the client a "state manager" (NBS) is not a good starting point; ask business whether this could help / support conversion later on...

## micro-frontends

- we do not have "real" micro-frontends, as the intention would be that each micro-service has its own frontend
- in our case it is not a big deal, as the whole vertical is owned by one team; it is more a deal of communication within the team and to think about when you want to deliver

- talked about the approach from AutoScout and Otto, which both use server side include with kind of pure HTML approach
- Otto is using overlays as well and frontend communication

- composing within the user Agent is totally fine, not much experience here
- communication at the user Agent with the owner in between seems to be a good approach

### Example of composed signup form

- discussion about whether each composed part should deal with their backend by their own, or having an owner collecting data and send it with just one call
- second one would more fit into the approach we are heading to with the API discussion (make it as simple as possible giving a client developer just one API)
- the owner could tell / ask the fragment to expose data; all exposed data would then be collected and added to certain sections for the call to the backend
- there needs to be a "signup backend" which needs to spread the data to the other verticals (same as in API discussion)

## MTTR culture

- MTTR - mean time to recover
- MTBF - mean time between failure
- focus on MTTR instead of MTBF (failures will happen anyways)
- it is about mindset to fix / unblock "red lights" fast

## metrics about business success / failures

> Only when you measure you can say whether you are successful or not

- implement a metric for the signup flow and execute it **very** frequently (every 5 seconds for instance)
- measure how often it breaks
- speek to the business about the expectations
- apply these expectation also to other business features

## feature toggles

- should apply at the very first entry point of the feature; Example:
	- thank-you page should now display also the name
	- the toggle would take place at the client-ui
	- there the decision is made which backend call to make / what to expect
- an easy path to follow could be that every service of vertical is referencing to a "toggle" configmap
	- downside: time to recover is higher, because you need to restart to apply changes)
- there could be a service within the vertical holding the state of features; every service of the vertical is asking for the state synchronously
	- downside: synchronous request; single point of failure; what is in that case the default
	- good thing is you can change state on runtime
- limit the check to a simple "IF" to remove them easily afterwards
- cover it also at the tests (both states)
- find a way to remove feature toggles in a ordered way
