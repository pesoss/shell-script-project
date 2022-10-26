# Shell-script-project-1

When submitting OS assignments in moodle, you must comply with the following requirements:

    - one archive in tar format compressed with xz
    
    - the name of the archive is FN .tar.xz
    
    - there is one directory in the archive
    

After all students have submitted their work, moodle makes it available under
the format of a .zip archive with a certain structure. The works are then unpacked
from a script that unpacks the works into a form convenient for inspection.

Your task will be to write a variant of this script (unpack.sh).

The script must take 4 arguments:

    - name of an existing .zip file formatted by moodle
    
    - name of a directory that does not exist and must be created by
      the script in which it should unpack the works
      
    - name of a directory that does not exist and must be created by
      the script where he has to copy the jobs he can't
      to cope
      
    - filename that does not exist and must be created by the script
      and contain information about the result of the unpacking

Example call:

    ./unpack.sh moodle.zip /tmp/result /tmp/unfinished /tmp/result.txt

In the directory with the condition you have given a real sample file downloaded from moodle
and sample output from calling the unpack script:

    ./unpack.sh 'example/C484487S2-Home #0-241777.zip' 
                'example/ok example/failed example/flags.txt

You can assume that each of the directories in the submitted archive starts
with the faculty number of the respective student, followed by a dash.
IMPORTANT: this is where your script is guaranteed to take from
the correct faculty number of the given student.

Each work must be unpacked in a directory named the faculty number
of the student located in the results directory.

Your script should be able to handle the following exceptions, yes
mark (*) if any of these occur, and unpack the job properly:

    - wrong name (FN) of the archive
    
    - wrong archive extension
    
    - wrong archive format (tar+gz, tar+bz2, zip, rar)
    
    - missing directory in the archive
    
    - wrong directory name in archive

Also, your script should detect the following exceptions
and upon encountering one, to copy the work into a directory named the faculty number
of the student, located in the unfinished directory:

    - wrong archive format (none of the above)
    
    - error running the dearchiver
    
    - more than one file submitted to moodle

(*) Outlier marking occurs in the file whose name is passed
as the fourth argument of the script (/tmp/result.txt in the example).

This file should contain one line for each *successfully* processed archive
and sorted by faculty number.

Each line must have the following format:

 fn gri grf nd grd

where:
   fn is faculty number
   gri is 1 if the archive name or extension is wrong and 0 otherwise
   grf is 1 if the archive format is wrong and 0 otherwise
   nd is 1 if there is no directory in the archive and 0 otherwise
   grd is 1 if the directory name in the archive is wrong and 0 otherwise

Your script can use external tools like unrar, unzip, etc.
Please describe used external tools in the documentation.
If you need any tool that is not available on astero, you can be
request to be installed in the question thread in the moodle forum.

P.S.: You can find the problem in Bulgarian in the problem.txt
