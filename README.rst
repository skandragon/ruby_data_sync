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
of the object unless otherwise

#. Each object must have a UUID.  This is the only identifier for this
   object, even if other local identifiers are added later to establish
   relationships between objects.
#. Each object must have a last-sync-time, which is maintained per peer.
   It may be stored with the object (for a client that syncs with a server)
   or in a separate table (for the server).
#. Each object must have a modification time that changes when it is
   modified locally.  When syncing, it is updated to the greater of the
   two peer's modification times.
#. A table of deleted object UUIDs must be maintained, and transmitted
   to the peer during sync.  If the peer does not have that object,
   it need not be propagated, but otherwise it must be ensured that
   the deletion entry is retained until all known peers have received it.

----------------
Applicaiton Data
----------------

The exact format of the objects is application dependent.  Relationships
between objects may have to be reconstructed on either end, and each
object may need some transformation before transmitting it to a peer.

A very common SQL-style object graph may have a one-to-one, one-to-many,
or many-to-many relationship.  Each of these may be handled in different
ways, including packaging the concept of an "object" to include related,
owned data and transmitting this as the synced object.  This is a workable
solution for one-to-one and one-to-many relationships in many cases.

Another approach would be to denormalize and re-establish the relationships
on receiving.  This would be workable for simple many-to-many relationships,
such as a tagging system.  Denormalizing the data and transmitting the
tags on an object as UUIDs, or as names, could assist in recreating this
graph.  However, it would require transmitting data in a dependency graph
order, or a final commit fix-up phase.

---------
Data Flow
---------

#. Establish network session.  One side will be the master, and one side will
   be the client.  Often, a server which many clients sync to will be
   forced to be a master.
#. Generate a list of UUIDs and modification times for objects which have a
   modification time after the last time we have synced with this peer.
   (master, client)
#. Generate a list of deleted objects.
#. Master will transmit its version of the these lists to the client.
#. Client will delete any objects which the master says are deleted.  If there
   are local modifications, it may log a conflict, but the object should
   still be deleted.
#. For each object the client has but the master does not, it should be
   transmitted to the master.
#. For each object the master has but the client does not, it should be
   received from the master.
#. For each object changed on the master, but not on the client, receive
   it.
#. For each object changed on the client but not on the master, transmit
   it.
#. If an object has been changed on both the master and the client, use
   the object with the most recently modified timestamp, and log that there
   was a conflict.

---------
Copyright
---------

Copyright (c) 2014 Michael Graff. See LICENSE.txt for further details.
