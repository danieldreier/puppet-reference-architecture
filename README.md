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
