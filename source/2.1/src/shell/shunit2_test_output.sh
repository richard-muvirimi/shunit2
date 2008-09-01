#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for actual output

# load test helpers
. ./shunit2_test_helpers

#------------------------------------------------------------------------------
# suite tests
#

# Note: the test script is prefixed with '#' chars so that shUnit2 does not
# incorrectly interpret the embedded functions as real functions.
testUnboundVariable()
{
  sed 's/^#//' >"${testF}" <<EOF
## treat unset variables as an error when performing parameter expansion
#set -u
#
#boom() { x=\$1; }  # this function goes boom if no parameters are passed!
#test_boom()
#{
#   assertEquals 1 1
#   boom  # No parameter given
#   assertEquals 0 \$?
#}
#. ${TH_SHUNIT}
EOF
  ( exec sh "${testF}" >"${stdoutF}" 2>"${stderrF}" )
  assertFalse 'expected a non-zero exit value' $?
  grep '^ASSERT:Unknown failure' "${stdoutF}" >/dev/null
  assertTrue 'failure message was not generated' $?
  grep '^Ran [0-9]* test' "${stdoutF}" >/dev/null
  assertTrue 'the failure message was not generated' $?
  grep '^FAILED' "${stdoutF}" >/dev/null
  assertTrue 'the failure message was not generated' $?
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  tmpDir="${__shunit_tmpDir}/output"
  mkdir "${tmpDir}"
  stdoutF="${tmpDir}/stdout"
  stderrF="${tmpDir}/stderr"
  testF="${tmpDir}/unittest"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}