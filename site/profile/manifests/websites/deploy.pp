# == Class: profile::websites::deploy
#
# This class was created to setup the deploy user that is needed accross all Drupal sites and MC
#
# This is copied from profile::plcomweb::deploy in anticipation of removing plcomweb, in order
# to make changes to it without needing to make those changes to production servers running
# on plcomweb.
#
class profile::websites::deploy {

  ### Deploy User Setup:
  ## This is the deploy user that is used for the capistrano deployments.
  ## We are using the same key so that it will be easy to deploy to all the boxes at the same time.
  ## It uses this key to ssh to the server to run the drush commands, move required drupal files, and to pull from github.
  ## For the sake of being easy right now we are using the same key on all the boxes. To change this in the future
  ## you will need to add the key to the pl-ops github account and give access to each key to talk with the correct server.

  # Create User
  user { 'deploy':
    ensure     => 'present',
    groups     => ['www-data' ],
    uid        => '99',
    managehome => true,
    shell      => "/bin/bash",
  }

}
