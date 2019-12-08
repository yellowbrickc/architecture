# Performance

## [RAIL](https://developers.google.com/web/fundamentals/performance/rail) performance model

- **R** -> Response: process events in under 50ms
- **A** -> Animation: produce a frame in 10ms
- **I** -> Idle: maximize idle time
- **L** -> Load: deliver content and become interactive in under 5 seconds

The time recommendations are based on the: 

**User Perception of Performance Delays**

| Time elapsed | User expectation |
| ------------ | ---------------- |
| 0 - 16ms     | Users are exceptionally good at tracking motion, and they dislike it when animations aren't smooth. They perceive animations as smooth so long as 60 new frames are rendered every second. That's 16ms per frame, including the time it takes for the browser to paint the new frame to the screen, leaving an app about 10ms to produce a frame. |
| 0 - 100ms | 	Respond to user actions within this time window and users feel like the result is immediate. Any longer, and the connection between action and reaction is broken. | 
| 100 - 300ms  | Users experience a slight perceptible delay. |
| 300 - 1000ms | Within this window, things feel part of a natural and continuous progression of tasks. For most users on the web, loading pages or changing views represents a task. |
| 1000ms+      | Beyond 1000 milliseconds (1 second), users lose focus on the task they are performing. |
| 10000ms+     | Beyond 10000 milliseconds (10 seconds), users are frustrated and are likely to abandon tasks. They may or may not come back later. |

## User-centric Performance Metrics

### First paint and first contentful paint

- first paint
  > marks the point when the browser renders anything that is visually different from what was on the screen prior to navigation
- first contentful paint
  > is the point when the browser renders the first bit of content from the DOM
- first meaningful paint
  > metric that answers the question: "is it useful?"
  
  useful = the most useful part of a page => so called hero element
    - individual for every page
    - focus on most important part of a page
    - no metric available via standardized API

=> [Paint Timing API](https://w3c.github.io/paint-timing/)

Browser-Support: Chrome and Opera only

### Long tasks

[W3C Long Tasks API](https://w3c.github.io/longtasks/)
[User Timing Specs](https://speedcurve.com/blog/user-timing-and-custom-metrics/)

Browser Support: Chrome only

### Time to interactive

[Google TTI-Polyfill](https://github.com/GoogleChromeLabs/tti-polyfill)

Workaround using a PerformanceObserver which has to be registered in the page head before any other JavaScript.

PerformanceObserver API Browser Support: Chrome, Firefox and Opera only

### Tracking input latency

Compare the event's timestamp to the current time and report it when the difference is above 100ms.

=> needs to be implemented on a page element basis in order to be tracked

### Load abandonment

Load abandonment can be tracked by adding a listener to the `visibilitychange` event (fires when page is being unloaded or going into background) and populating `performance.now()` via `sendBeacon()`

# Beacon API

Beacon API is a [W3C](https://w3c.github.io/beacon/) standard with status Candidate Recommendation from April 13th, 2017.
It defines a single method **sendBeacon** with two arguments:
  
1. url - required
2. data - optional

The `data` argument accepts the following types:
- ArrayBufferView
- Blob
- DOMString
- FormData

When calling the *sendBeacon* method, an asynchronous and non-blocking *HTTP POST* request is sent which doesn't require a response.

> Compare topic [Global Context](https://developer.mozilla.org/en-US/docs/Web/API/Beacon_API#Global_context)
> Requests are guaranteed to be initiated before a page is unloaded and they are run to completion, without requiring a blocking request

## Browsersupport

- Global Context
  - Desktop: all except IE
  - Mobile: all except iOS Safari and Samsung Internet

- Worker Context
  - Desktop: Chrome and Opera only
  - Mobile: Chrome, Opera and Android Webview only

=> Worker Context is out of scope due to lack of supperted browsers especially on mobile devices

## Performance measuring points

*performance.getEntriesByType("navigation")[0]*

- Connection Establishment
  - DNS lookup
    - domainLookupStart
    - domainLookupEnd
  - Connection negotioation
    - connectStart
    - secureConnectionStart
    - connectEnd
  - Request/Response
    - fetchStart
    - workerStart
    - requestStart
    - responseStart
    - responseEnd
  - Page unload event
    - unloadEventStart
    - unloadEventEnd
  - Redirects
    - redirectStart
    - redirectEnd
  - Loading
    - loadEventStart
    - loadEventEnd
  - Document and resource size
    - transferSize
    - endodedBodySize
    - decodedBodySize

## [User Timing Spec](https://speedcurve.com/blog/user-timing-and-custom-metrics/)

[W3C User Timing Spec](https://www.w3.org/TR/user-timing/)

- performance.mark
  > records the time (in milliseconds) since navigationStart
- performance.measure
  > records the delta between two marks
- performance.clearMarks

## Code examples

### Performance Values
```
// Cache seek plus response time
var pageNav = performance.getEntriesByType("navigation")[0];
var fetchTime = pageNav.responseEnd - pageNav.fetchStart;

// Service worker time plus response time
var workerTime = 0;

if (pageNav.workerStart > 0) {
  workerTime = pageNav.responseEnd - pageNav.workerStart;
}

// Request plus response time (network only)
var totalTime = pageNav.responseEnd - pageNav.requestStart;

// Response time only (download)
var downloadTime = pageNav.responseEnd - pageNav.responseStart;

// Time to First Byte (TTFB)
var ttfb = pageNav.responseStart - pageNav.requestStart;

// HTTP header size
var pageNav = performance.getEntriesByType("navigation")[0];
var headerSize = pageNav.transferSize - pageNav.encodedBodySize;

// Compression ratio
var compressionRatio = pageNav.decodedBodySize / pageNav.encodedBodySize;
```

### Listen for performance entries using PerformanceObserver
```
// Instantiate the performance observer
var perfObserver = new PerformanceObserver(function(list, obj) {
  // Get all the resource entries collected so far
  // (You can also use getEntriesByType/getEntriesByName here)
  var entries = list.getEntries();

  // Iterate over entries
  for (var i = 0; i < entries.length; i++) {
    // Do the work!
  }
});

// Run the observer
perfObserver.observe({
  // Polls for Navigation and Resource Timing entries
  entryTypes: ["navigation", "resource"]
});

// Should we even be doing anything with perf APIs?
if ("performance" in window) {
  // OK, yes. Check PerformanceObserver support
  if ("PerformanceObserver" in window) {
    // Observe ALL the performance entries!
  } else {
    // WOMP WOMP. Find another way. Or not.
  }
}
```

### Using navigator.sendBeacon
```
window.addEventListener("unload", function() {
  // Collect RUM data like before
  let rumData = new FormData();
  rumData.append("entries", JSON.stringify(performance.getEntries()));

  // Check for sendBeacon support:
  if("sendBeacon" in navigator) {
    // Beacon the requested
    if(navigator.sendBeacon(endpoint, rumData)) {
      // sendBeacon worked! We're good!
    } else {
      // sendBeacon failed! Use XHR or fetch instead
    }
  } else {
    // sendBeacon not available! Use XHR or fetch instead
  }
}, false);
```