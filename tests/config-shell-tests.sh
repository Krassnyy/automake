#! /bin/sh
# Copyright (C) 2011 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Driver script to run checks on Automake-provided shell scripts using
# configure-time $SHELL instead of the system shell /bin/sh.

set -e

fatal_ () { echo "$0: $*" >&2; exit 99; }

# Ensure proper definition of $testsrcdir.
. ./defs-static || exit 99
test -n "$testsrcdir" || fatal_ "\$testsrcdir is empty or undefined"

case $#,$1 in
  0,) fatal_ "missing argument";;
  1,*-w.shtst) test_name=`expr /"$1" : '.*/\(.*\)-w\.shtst'`;;
  1,*) fatal_ "invalid argument \`$1'";;
  *) fatal_ "too many arguments";;
esac

# Run the test using configure-time $SHELL, not /bin/sh, to run the
# checked shell scripts.
test_prefer_config_shell=yes
# This is required to have the wrapped test use a proper temporary
# directory to run into.
me=$test_name-w
# In the spirit of VPATH, we prefer a test in the build tree
# over one in the source tree.
if test -f "./$test_name.test"; then
  . "./$test_name.test"
  exit $?
elif test -f "$testsrcdir/$test_name.test"; then
  . "$testsrcdir/$test_name.test"
  exit $?
else
  fatal_ "cannot find wrapped test \`$test_name.test'"
fi

exit 255 # Not reached.