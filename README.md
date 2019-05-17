# WorkScripts
Scripts I created to make my job a little faster

I've written or adapted these scripts while working largely on a remote Linux server to simplify some tasks I have to do frequently, or solve complex problems I encounter every once in a while.

The big kids on this playground are:

 - [old_ver.sh](https://github.com/BurnsCommaLucas/WorkScripts/blob/master/old_ver.sh): This script goes into our old version control system and figures out what revisions of a given file contain a given string
 - [active.sh](https://github.com/BurnsCommaLucas/WorkScripts/blob/master/active.sh): This one moves things around my personal work directories, and handles permission changes automatically so I don't have to play hard-ball after creating files as the wrong user.
 - [log_check.sh](https://github.com/BurnsCommaLucas/WorkScripts/blob/master/log_check.sh): Recursively checks the current directory for pesky odbc.log files which can get pretty big in size without anyone noticing.

I only really update these scripts as I find inconsistencies/problems or find functionality the need added. Active.sh has been fairly refined by now, so it's not updated much, and some scripts don't get a lot of use so they likely won't be updated much either.
