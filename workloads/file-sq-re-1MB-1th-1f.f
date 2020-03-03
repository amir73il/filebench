set mode quit alldone
set $dir=/mnt
set $nfiles=1
set $meandirwidth=1
set $nthreads=1

#Fix I/O amount to 10 G
define fileset name=bigfileset, path=$dir, entries=$nfiles, dirwidth=$meandirwidth, size=10g, prealloc

define process name=fileopen, instances=1
{
        thread name=fileopener, memsize=1m, instances=$nthreads
        {
                flowop openfile name=open1, filesetname=bigfileset, fd=1
                flowop read name=read-file, iosize=1m, iters=10240, fd=1
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
