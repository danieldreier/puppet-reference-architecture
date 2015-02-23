puppet-reference-architecture
=============================

A puppet site "module" for running a basic infrastructure, as an example. Not production ready!

### What is this?

I needed infrastructure to use in developing, testing, and demonstrating [puppet-puppet](https://github.com/puppetlabs-operations/puppet-puppet),
[puppet-trigger](https://github.com/danieldreier/puppet-trigger), and other tools I'm interested in. 

Unfortunately, real infrastructure usually has secrets in it, has technical debt, etc. It's hard to
update even after you learn better ways of doing things, and hard to share because you have to communicate
the reason you did that dumb thing and why it has to be that way.

Idealized model infrastructure has no such limitations. I'm hoping to put together the infrastructure I wish I had,
based on the infrastructure I do work with.


### Getting started

If you're using etcd (this does by default) you'll need to put a new etcd
discovery token in extdata/common.yaml each time you fully stop and start
the infrastructure, as is the common case with vagrant.


### How to use this for module development

1. Create a "modules" folder and put your module(s) in it
2. `vagrant up puppetmaster`
3. `puppet agent --test` in the master


### Naming scheme
group-application##-stage.example.com

### How to set up infrastructure from scratch

- provision a system to act as an all-in-one puppet master. We'll call this puppet-aio01-prod.example.com.
- configure DNS A and AAAA records for the master. (yes, you, use IPv6)
- configure a DNS SRV record `_x-puppet._tcp.example.com. IN SRV 0 5 8140 puppet-aio01-prod.example.com`.

we're provisioning using a FreeBSD server on Digital Ocean, so instructions will be a bit specific to that environment

