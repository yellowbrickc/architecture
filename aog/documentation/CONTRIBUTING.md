# Contributing to AOG documentation

First off, thanks a lot for taking time to contribute to our common architectural documentation repository. The following describes a few rules and guidelines to get contributions in an ordered way.

## How can I contribute?

### Suggesting Enhancements

Enhancement suggestions are tracked as Gitlab issues. Create an issue on this repository and provide the following information:

- Use a clear and descriptive title for the issue to identify the suggestion.
- Provide a step-by-step description of the suggested enhancement in as many details as possible.
- Explain why this enhancement would be useful

### Create a merge request

Follow the [Gitlab merge request documentation](https://docs.gitlab.com/ee/gitlab-basics/add-merge-request.html) guidelines.

## General hints when contributing

### Table of Contents (TOC)

Please note that some of the Markdown files do have a auto generated Table of Content. In case you are changing those files structure or adding new headlines, please regenerate the TOC.

First install doctoc tool:

    npm install -g doctoc

Regenerate TOC's (from repository root):

    doctoc architectural-outline/README.md --gitlab --title '# Table of Contents' --maxlevel 4

### Changelog

Please look after the Changelog entries. May you did a change (except e.g. fixing some typo's, etc...) which is good to notice at the [Changelog](./architectural-outline/README.md#changelog) table.

### Links

When changing / moving headlines, please always check whether referencing anchors need to get updated.