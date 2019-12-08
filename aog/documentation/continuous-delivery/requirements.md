# Requirements an die sub.rocks CD Pipeline

- No feature-branch support in the delivery pipeline

- Usability during daily development usage

    - want to see error quickly
    - want to have an intuitive overview of my / all pipelines, so that I can see the status quickly
    - want to see the dependencies of my pipeline, so that I see what triggers my pipeline for which reason
    - want to compare the result of different pipeline flows, so that I can see which changes caused an error
    - want to get notified (Email, SMS, Slack, ...) in any case of unexpected pipeline behaviour, so that I can fix the problem fast
    - want to have very quick feedback from the very first project pipeline steps, so that can continue work quickly / fix causing problems as soon as possible
    - want to run the pipeline locally to test a new developed / changed pipeline

- Maintainability by the developers

    - want to be able to add new pipelines by my own, so that I am able to try new things without any dependency to other teams
    - want to define dependencies and triggers of my pipelines so that I can combine multiple pipelines
    - want not to repeat myself all the time and profit from other developers pipeline experience easily, to save time and keep consistency
    - want to optimize specific pipeline steps by my own, so that I am able to get best delivery for my piece of software
    - want to be able to add / update quality gates to pipelines by my own, so that I can ensure that the delivered software fulfills our quality requirements
    - want to be able to add / update security gates to pipelines by my own, so that I can ensure that the delivered software fulfills our security requirements

- Orchestration of delivery

    - want to bundle multiple pipeline results for delivery, so that I can be sure that the right pieces of software work together well and passed all quality gates
    - want to give a version to delivery bundle
    - want to be able to rollback to specific bundle versions at any time, so that I am able in case of failures to fix the issue quickly
    
- Automatisation    
    
    - want to be able to automatically deliver to specific environments, so that users can give feedback fast
    - want to be able to manually deliver to specific environments, so that I am able to control time and ... of the delivery process

- Status Monitoring

    - want to get an overview of currently deployed versions of each environment, so that I always know which "status" an environment has
    - want to publish pipeline results (security reports, test results, vulnerabilities, ...)

- Release

    - want to control further pipeline steps by approval, so that the delivery passes by my acceptance of features
    - want to control deployment of feature sets by approval, so that the delivery passes by my acceptance of features and review of stakeholders
