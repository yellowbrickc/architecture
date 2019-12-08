

## Tasks

### Iteration 1 @QOG

- provide selenium standalone container
- create "test-runner" repo
    - create script to create test-runner Job
    - create "status" script (and delete Job)
- create jenkins job (using test-runner repo)

### Iteration 2 @PaaS, QOG

- provide S3 bucket (writable by k8s nodes, readable by office)
- add s3 volume share to test-runner job
- do not log to stdout anymore (e2eContainer) -> logfiles

### Iteration 3

- rollout to the teams
- tbd

### Iteration 4 @TBD

- create test-reporter Jenkins Job
    - get report dir from previous Job
- create test-reporter Repo
    - create script to create test-reporter Job
    - create "status" script (and delete Job)
- provide test-reporter container
    - generate HTML report
    - update index.html
    - publish (using solution from Iteration 2 S3 volume share vs. S3 API call...)
