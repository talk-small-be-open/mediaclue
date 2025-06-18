#!/bin/bash

# source $(dirname "$0")/lib.sh

# On Linux, all the opened files and sockets from the parent process (which is Pharo), will be inherited to subprocesses.
# Thats kind of stupid, we have to explicitlty close them, since the web server socket will be kept by the subprocess
# and if Pharo saves the image, it releases the sockets and immediately wants to get them again, but that will fail,
# since the subprocess still has it (unused) open

# TODO: This should be done in Pharo by OSSSubprocess, see stub method closeAllButStandardFileStreams

# Find file descriptor of open socket on pharos port
MYPID=$$

# Get tcp sockets. Ignoring first line, since lsof always outputs the PID there
fileDescriptors=$(lsof -a -p $MYPID -i tcp -F f | tail -n +2)

for fd in $fileDescriptors; do

		# Remove the first char "f", leaving the number
		fileDescriptor="${fd:1}"

		# Close the open socket file descriptor for that process,
		# so that it does not stick to it. (Its the parent web server listening socket)
		# echo "exec $fileDescriptor>&-"
		eval "exec $fileDescriptor>&-"

done

PWD=$1
shift

OUTFILE=$1
shift

COMMAND=$1
shift

# Run the initially given command line.
# eval "$(token_quotes "$@")" > $OUTFILE

pushd $PWD > /dev/null

# Test, if we have arguments for the command, or not
if [ "$#" -eq 0 ]; then
  # If it is only one single command without arguments, then we evaluate it lierally,
  # so that we can use that for a complex command which is given directly as a single string, even with
  # bash syntax. Not the safest, but very handy sometimes.
  ( eval $COMMAND ) 1> $OUTFILE 2> /tmp/mediaclue-execute-subprocess-error.log
else
  $COMMAND "$@" 1> $OUTFILE 2> /tmp/mediaclue-execute-subprocess-error.log
fi


popd > /dev/null
