# avchkpt
Avamar 7.x checkpoint create and validation script.

## Install and Run

```
# unzip avchkpt-1.1.zip
# cd avchkpt-1.1
# ./avchkpt.sh 
16.12.01 14:38:41 : ./avchkpt.sh version: 1.1
usage --list | --create [ 1 | 2 ] [ full | rolling ]
   --list   - list current checkpoints
   --create - create 1 or 2 checkpoints (default is 1), validate full or rolling
16.12.01 14:38:41 : All done

```
## Warning validating a checkpoint on a large system will take a long time

To run and full validate a checkpoint:
```
./avchkpt.sh --create 1

```

Sample output below:
```
16.12.01 14:30:56 : ./avchkpt.sh version: 1.1
16.12.01 14:30:56 : Flushing MC Server data
=== BEGIN === check.mcs (preflush)
check.mcs                        passed
=== PASS === check.mcs PASSED OVERALL (preflush)
Flushing Administrator Server...
Administrator Server flushed.
16.12.01 14:31:10 : Creating a checkpoint
16.12.01 14:31:10 : Running cmd: mccli checkpoint create  --override_maintenance_scheduler\=true
0,22624,Starting to create a server checkpoint.

16.12.01 14:31:15 : Waiting 30 seconds for the checkpoint to be created
16.12.01 14:31:48 : Running cmd: mccli checkpoint show
0,23000,CLI command completed successfully.
Tag               Time                    Validated Deletable
----------------- ----------------------- --------- ---------
cp.20161201191440 2016-12-01 14:14:40 EST Validated Yes
cp.20161201192407 2016-12-01 14:24:07 EST Validated No
cp.20161201193119 2016-12-01 14:31:19 EST           No

16.12.01 14:31:52 : Validating the checkpoint cp.20161201193119
16.12.01 14:31:52 : Running cmd: mccli checkpoint validate --cptag=cp.20161201193119 --checktype=full  --override_maintenance_scheduler\=true
0,22612,Starting to validate a server checkpoint.
Attribute Value
--------- -----------------
tag       cp.20161201193119
type      Full

16.12.01 14:31:59 : Waiting for the validation to be In Progress...
cp.20161201193119 2016-12-01 14:31:19 EST In Progress No
.
.
cp.20161201193119 2016-12-01 14:31:19 EST In Progress No
16.12.01 14:34:00 : Running cmd : mccli checkpoint show | grep cp.20161201193119
cp.20161201193119 2016-12-01 14:31:19 EST Validated No
16.12.01 14:34:04 : Running cmd: mccli checkpoint show
0,23000,CLI command completed successfully.
Tag               Time                    Validated Deletable
----------------- ----------------------- --------- ---------
cp.20161201191440 2016-12-01 14:14:40 EST Validated Yes
cp.20161201192407 2016-12-01 14:24:07 EST Validated No
cp.20161201193119 2016-12-01 14:31:19 EST Validated No

16.12.01 14:34:08 : All done


