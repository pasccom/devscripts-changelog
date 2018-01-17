#!/bin/sh
#
# Copyright 2018 Pascal COMBES <pascom@orange.fr>
# 
# This file is part of devscripts-changelog.
# 
# devscripts-changelog is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# devscripts-changelog is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with devscripts-changelog. If not, see <http://www.gnu.org/licenses/>

[ -d results ] || mkdir results
[ -d results/create ] || mkdir results/create
[ -d results/append ] || mkdir results/append

# For create test case:
for FILE in $(ls tests/create/output); do
    echo "Executing on create testcase: $FILE"
    [ -f "resultcreate/${FILE}" ] || sed -e 's/^.* (.*+\(.*\)) .*; urgency=.*$/%PACKAGE% (%VERSION%+\1) %AREA%; urgency=%URGENCY%/' \
                                         -e 's/^ -- .*$/ -- %MAINTAINER%/' "tests/create/output/${FILE}" > "results/create/${FILE}"
done

# For append test case:
for FILE in $(ls tests/append/output); do
    echo "Executing on append testcase: $FILE"                             
    [ -f "resultappend/${FILE}" ] || sed -e 's/^.* (.*+\(.*\)) .*; urgency=.*$/%PACKAGE% (%VERSION%+\1) %AREA%; urgency=%URGENCY%/' \
                                         -e 's/^ -- .*$/ -- %MAINTAINER%/' "tests/append/output/${FILE}" > "results/append/${FILE}"
done
