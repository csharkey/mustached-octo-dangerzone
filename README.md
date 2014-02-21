# Homework

## Context

You work at some-company.com, managing the Apache web server.  This repo's [`access.log`](/access.log) contains a 4-month slice of your company's access logs.

## Task

1. Write a tool that parses `access.log` and provides the [statistical
   breakdowns below](/#breakdowns)
    * Use the language of your choice
    * Write the tool as if it would be used in production and maintained
      by a team of your peers
    * Bonus points for tests
    * Bonus points for packaging for deployment
1. Implement at least one of the [bonus breakdowns or features below](/#bonuses)
1. Submit your code
    * A tarball in an email attachment is ok
    * Bonus points for [forking this repo](https://help.github.com/articles/fork-a-repo) and issuing a [pull request](https://help.github.com/articles/creating-a-pull-request)

## Breakdowns

* queries per second
* top requestors
* top requested pages
* responses
* browsers used
* web crawlers

## Bonuses 

### Bonus Breakdowns

* ISPs used by requesters
* geographic location of requesters
* attacks against our server

### Bonus Features

* Make the tool optionally report in real time
* Create a counterpart tool that takes as input the statistical
  breakdowns and produces a randomized `access.log` that conforms
  to those stats
