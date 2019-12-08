# Subscription Domain Events

All domain events which are distributed on the domain event bus shall be stored here and used to implement domain events. This is the single source of truth. If new events arise, add them here and release new versions of the package.

# How to update, add, delete events?

Please make sure you are aware of the listed conventions and be careful with compatibly as it may breaks consuming applications.
    
- [Architectural domain event definition](./documentation/blob/master/architectural-outline/README.md#domain-events)

Define the schema of your events based on above conventions.

## Exposing events

At the index.js file you will find a structure where all JSON schemas are require()d. This is used to automatically expose an object to an application using this package in the format below to easily work with it in the application.

```javascript
{
	%eventType-1%: {
		...%json-schema-1%
	},
	%eventType-2%: {
		...%json-schema-2%
	},
}
```

Once you add or change an event make sure to put it in the list as well so that others can work with it without deep requiring the JSON schemas directly.

**Note that there are tests on the file which will check whether all JSON schemas in the repository are also exposed. If not the test will fail!**

## Changelog

There is a `CHANGELOG.md` at root. Please at some notes there so that other know what changed and in case how to migrate to a newer package version.

