#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Use a preallocated fileset with a fairly deep directory tree -
# do readdir operations on them for a specified amount of time
#
set $dir=/mnt
set $nfiles=50000
set $meandirwidth=100
set $meanfilesize=16k
set $nthreads=16

define fileset name=bigfileset,path=$dir,size=$meanfilesize,entries=$nfiles,dirwidth=$meandirwidth,reuse,trusttree

define process name=lsdir,instances=1
{
  thread name=dirlister,memsize=1m,instances=$nthreads
  {
    flowop listdir name=readdir,filesetname=bigfileset
  }
}

echo  "ListDirs Version 1.0 personality successfully loaded"
system "sync"
system "echo 3 > /proc/sys/vm/drop_caches"
psrun -10
