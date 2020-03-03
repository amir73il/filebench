set mode quit alldone
set $dir=/mnt
set $nfiles=1
set $nthreads=32
#Fixing combined I/O amount to be some 1 G (HDD)
set $memsize=4k
set $iterations=8192

define file name=bigfileset, path=$dir, size=6g, prealloc

define process name=fileopen, instances=1
{
        thread name=fileopener, memsize=$memsize, instances=$nthreads
        {
                flowop openfile name=open1, filesetname=bigfileset, fd=1
                flowop read name=read-file, random, iosize=$memsize, iters=$iterations, fd=1
                flowop closefile name=close1, fd=1
                flowop finishoncount name=finish, value=1
        }
}
create files

system "sync"
system "echo 3 > /proc/sys/vm/drop_caches"
system "echo started >> cpustats.txt"
system "echo started >> diskstats.txt"
psrun -10
