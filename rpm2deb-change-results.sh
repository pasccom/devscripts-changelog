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
