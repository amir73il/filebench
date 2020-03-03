set mode quit alldone
set $dir=/mnt
set $nthreads=1

#Fix I/O amount to 10 G
define file name=bigfileset, path=$dir, size=10g

define process name=fileopen, instances=1
{
        thread name=fileopener, memsize=1m, instances=$nthreads
        {
                flowop createfile name=create1, filesetname=bigfileset
                flowop write name=write-file, filesetname=bigfileset, iosize=1m,iters=10240
                flowop closefile name=close1
                flowop finishoncount name=finish, value=1
        }
}
create files
system "sync"
system "echo 3 > /proc/sys/vm/drop_caches"
system "echo started >> cpustats.txt"
system "echo started >> diskstats.txt"
psrun -10
