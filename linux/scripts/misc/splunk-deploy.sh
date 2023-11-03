#!/bin/sh

# This script provides an example of how to deploy the universal forwarder
# to many remote hosts via ssh and common Unix commands.
#
# Note that this script will only work unattended if you have SSH host keys
# setup & unlocked.
# To learn more about this subject, do a web search for "openssh key management".


# ----------- Adjust the variables below -----------

# Populate this file with a list of hosts that this script should install to,
# with one host per line.  You may use hostnames or IP addresses, as
# applicable.  You can also specify a user to login as, for example, "foo@host".
#
# Example file contents:
# server1
# server2.foo.lan
# you@server3
# 10.2.3.4

HOSTS_FILE="hosts.txt"

# This is the path to the tar file that you wish to push out.  You may
# wish to make this a symlink to a versioned tar file, so as to minimize
# updates to this script in the future.

SPLUNK_FILE="/opt/splunkforwarder-8.2.3-cd0848707637-Linux-x86_64.tgz"

# This is where the tar file will be stored on the remote host during
# installation.  The file will be removed after installation.  You normally will
# not need to set this variable, as $NEW_PARENT will be used by default.
#
# SCRATCH_DIR="/home/your_dir/temp"

# The location in which to unpack the new tar file on the destination
# host.  This can be the same parent dir as for your existing 
# installation (if any).  This directory will be created at runtime, if it does
# not exist.

NEW_PARENT="/opt"

# After installation, the forwarder will become a deployment client of this
# host.  Specify the host and management (not web) port of the deployment server
# that will be managing these forwarder instances.  If you do not wish to use
# a deployment server, you may leave this unset.
#
DEPLOY_SERV="192.168.69.30:8089"

# A directory on the current host in which the output of each installation
# attempt will be logged.  This directory need not exist, but the user running
# the script must be able to create it.  The output will be stored as
# $LOG_DIR/<[user@]destination host>.  If installation on a host fails, a
# corresponding file will also be created, as
# $LOG_DIR/<[user@]destination host>.failed.

LOG_DIR="/tmp/splunkua.install"

# For conversion from normal Splunk Enterprise installs to the universal forwarder:
# After installation, records of progress in indexing files (monitor)
# and filesystem change events (fschange) can be imported from an existing
# Splunk Enterprise (non-forwarder) installation.  Specify the path to that installation here.
# If there is no prior Splunk Enterprise instance, you may leave this variable empty ("").
#
# NOTE: THIS SCRIPT WILL STOP THE SPLUNK ENTERPRISE INSTANCE SPECIFIED HERE.
#
# OLD_SPLUNK="/opt/splunk"

# If you use a non-standard SSH port on the remote hosts, you must set this.
# SSH_PORT=1234

# You must remove this line, or the script will refuse to run.  This is to
# ensure that all of the above has been read and set. :)

UNCONFIGURED=0

# ----------- End of user adjustable settings -----------


# helpers.

faillog() {
  echo "$1" >&2
}

fail() {
  faillog "ERROR: $@"
  exit 1
}

# error checks.

test "$UNCONFIGURED" -eq 1 && \
  fail "This script has not been configured.  Please see the notes in the script."
test -z "$HOSTS_FILE" && \
  fail "No hosts configured!  Please populate HOSTS_FILE."
test -z "$NEW_PARENT" && \
  fail "No installation destination provided!  Please set NEW_PARENT."
test -z "$SPLUNK_FILE" && \
  fail "No splunk package path provided!  Please populate SPLUNK_FILE."
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR" || fail "Cannot create log dir at \"$LOG_DIR\"!"
fi

# some setup.

if [ -z "$SCRATCH_DIR" ]; then
  SCRATCH_DIR="$NEW_PARENT"
fi
if [ -n "$SSH_PORT" ]; then
  SSH_PORT_ARG="-p${SSH_PORT}"
  SCP_PORT_ARG="-P${SSH_PORT}"
fi

NEW_INSTANCE="$NEW_PARENT/splunkforwarder" # this would need to be edited for non-UA...
DEST_FILE="${SCRATCH_DIR}/splunk.tar.gz"

#
#
# create script to run remotely.
#
#

REMOTE_SCRIPT="
  fail() {
    echo ERROR: \"\$@\" >&2
    test -f \"$DEST_FILE\" && rm -f \"$DEST_FILE\"
    exit 1
  }
"

###   try untarring tar file.
REMOTE_SCRIPT="$REMOTE_SCRIPT
  (cd \"$NEW_PARENT\" && tar -zxf \"$DEST_FILE\") || fail \"could not untar /$DEST_FILE to $NEW_PARENT.\"
"

###   setup seed file to migrate input records from old instance, and stop old instance.
if [ -n "$OLD_SPLUNK" ]; then
  REMOTE_SCRIPT="$REMOTE_SCRIPT
    echo \"$OLD_SPLUNK\" > \"$NEW_INSTANCE/old_splunk.seed\" || fail \"could not create seed file.\"
    \"$OLD_SPLUNK/bin/splunk\" stop || fail \"could not stop existing splunk.\"
  "
fi

###   setup deployment client if requested.
if [ -n "$DEPLOY_SERV" ]; then
  REMOTE_SCRIPT="$REMOTE_SCRIPT
    \"$NEW_INSTANCE/bin/splunk\" set deploy-poll \"$DEPLOY_SERV\" --accept-license --answer-yes \
      --auto-ports --no-prompt || fail \"could not setup deployment client\"
  "
fi

###   start new instance.
REMOTE_SCRIPT="$REMOTE_SCRIPT
  \"$NEW_INSTANCE/bin/splunk\" start --accept-license --answer-yes --auto-ports --no-prompt || \
    fail \"could not start new splunk instance!\"
"

###   remove downloaded file.
REMOTE_SCRIPT="$REMOTE_SCRIPT
  rm -f "$DEST_FILE" || fail \"could not delete downloaded file $DEST_FILE!\"
"

#
#
# end of remote script.
#
#

exec 5>&1 # save stdout.
exec 6>&2 # save stderr.

echo "In 5 seconds, will copy install file and run the following script on each"
echo "remote host:"
echo
echo "===================="
echo "$REMOTE_SCRIPT"
echo "===================="
echo
echo "Press Ctrl-C to cancel..."
test -z "$MORE_FASTER" && sleep 5
echo "Starting."

# main loop.  install on each host.

for DST in `cat "$HOSTS_FILE"`; do
  if [ -z "$DST" ]; then
    continue;
  fi

  LOG="$LOG_DIR/$DST"
  FAILLOG="${LOG}.failed"
  echo "Installing on host $DST, logging to $LOG."

  # redirect stdout/stderr to logfile.
  exec 1> "$LOG"
  exec 2> "$LOG" 

  if ! ssh $SSH_PORT_ARG "$DST" \
      "if [ ! -d \"$NEW_PARENT\" ]; then mkdir -p \"$NEW_PARENT\"; fi"; then
    touch "$FAILLOG"
    # restore stdout/stderr.
    exec 1>&5 
    exec 2>&6
    continue
  fi

  # copy tar file to remote host.
  if ! scp $SCP_PORT_ARG "$SPLUNK_FILE" "${DST}:${DEST_FILE}"; then
    touch "$FAILLOG"
    # restore stdout/stderr.
    exec 1>&5 
    exec 2>&6
    continue
  fi
    
  # run script on remote host and log appropriately.
  if ! ssh $SSH_PORT_ARG "$DST" "$REMOTE_SCRIPT"; then
    touch "$FAILLOG" # remote script failed.
  else
    test -e "$FAILLOG" && rm -f "$FAILLOG" # cleanup any past attempt log.
  fi

  # restore stdout/stderr.
  exec 1>&5 
  exec 2>&6

  if [ -e "$FAILLOG" ]; then
    echo "  -->   FAILED   <--"
  else
    echo "      SUCCEEDED"
  fi
done

FAIL_COUNT=`ls "${LOG_DIR}" | grep -c '\.failed$'`
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "There were $FAIL_COUNT remote installation failures."
  echo "  ( see ${LOG_DIR}/*.failed )"
else
  echo
  echo "Done."
fi

