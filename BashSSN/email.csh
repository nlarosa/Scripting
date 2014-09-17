#!/bin/csh

# Nicholas LaRosa
# CSE 20189

set file = '/afs/nd.edu/courses/cse/cse20189.01/files/hw12/email.log'

set sent = "`grep -c 'stat=Sent' $file`"
set user = "`grep -c 'stat=User' $file`"
set deferred = "`grep -c 'stat=Deferred' $file`"
set discarded = "`grep -c 'Discarded:' $file`"
set rejected = "`grep -c 'reject=[0-9][0-9]*' $file`" 

echo ""
echo "File: $file"
echo ""

echo "Number sent: $sent"
echo "Number user: $user"
echo "Number deferred: $deferred"
echo "Number discarded: $discarded"
echo "Number rejected: $rejected"

echo ""

