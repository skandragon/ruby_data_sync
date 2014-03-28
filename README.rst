==============
ruby_data_sync
==============

|travis|_ |gemnasium|_ |codeclimate|_

.. |travis| image:: https://travis-ci.org/skandragon/ruby_data_sync.png?branch=master
.. _travis: https://travis-ci.org/skandragon/ruby_data_sync

.. |gemnasium| image:: https://gemnasium.com/skandragon/ruby_data_sync.png
.. _gemnasium: https://gemnasium.com/skandragon/ruby_data_sync

.. |codeclimate| image:: https://codeclimate.com/github/skandragon/ruby_data_sync.png
.. _codeclimate: https://codeclimate.com/github/skandragon/ruby_data_sync

This gem provides a multi-way data sync between databases and devices.
It does not require any specific database, but insteads asumes data to be
synced is represented by a Ruby hash.

Each database is called a "device" for lack of a better term.  Syncing between
devices happens two at a time.  The system is designed for a star
arrangement, where all devices sync with one central device.

--------
Metadata
--------

Each object has application data and sync metadata.  The sync metadata is
used during the sync process, while the application data is treated as
semi-opaque by the sync system.

Modificaitons to the metadata will not update the modification time
of the record unless otherwise

1. Each record must have a UUID.  This is the only identifier for this
   record, even if other local identifiers are added later to establish
   relationships between objects.
1. Each record must have a last-sync-time, which is maintained per peer.
   It may be stored with the record (for a client that syncs with a server)
   or in a separate table (for the server).
1. Each record must have a modification time that changes when it is
   modified locally.  When syncing, it is updated to the greater of the
   two peer's modification times.
1. A table of deleted record UUIDs must be maintained, and transmitted
   to the peer during sync.  If the peer does not have that record,
   it need not be propagated, but otherwise it must be ensured that
   the deletion entry is retained until all known peers have received it.

---------
Data Flow
---------

1. Establish network session.  One side will be the master, and one side will
   be the client.  Often, a server which many clients sync to will be
   forced to be a master.
1. Generate a list of UUIDs and modification times for records which have a
   modification time after the last time we have synced with this peer.
   (master, client)
1. Generate a list of deleted records.
1. Master will transmit its version of the these lists to the client.
1. Client will
1. For each new object (we have it, the remote does not) create an object.
1. For each object on the remote but not local, request it.
1. For each object changed locally, but not remotely, transmit it.
1. For each object changed on the remote, but not locally, receive it.
1. For conflicts, use the last modified time of the two records,
   and log that there was a conflict.

---------
Copyright
---------

Copyright &copy; 2014 Michael Graff. See LICENSE.txt for further details.
