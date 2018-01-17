#!/bin/sh

# Usage:
# rpm2deb-change-test [-d|-v] [testfile [testoptions ...]] 
#
# Options:
#   -d: Run in debug mode.
#   -v: Run in verbose mode.
#   testfile: run test only on this file
#   testoptions: options for rpm2deb-change

# Options processing:
DEBUG=0
case $1 in
    -d)
    DEBUG=2
    shift
    ;;
    -v)
    DEBUG=1
    shift
    ;;
    *)
    ;;
esac

# Selected file processing:
SELECTED_FILE=
if [ $# -ge 1 ]; then
    SELECTED_FILE="$1"
    shift
fi

source ./rpm2deb-change-local.sh
# DEFAULT_PACKAGE='devscripts-changelog'
# DEFAULT_VERSION='1.0.0'
# DEFAULT_DISTRIBUTION='unstable'
# DEFAULT_URGENCY='low'
# DEFAULT_MAINTAINER='Pascal Combes <pascom@orange.fr>'

# Run rpm2deb-change:
#   $1: testcase
#   $2: testfile
#   $@: options for rpm2deb-change
function genOutput() {
    local CASE
    local FILE
    
    # Arguments processing:
    CASE=$1
    shift
    FILE=$1
    shift
    
    # Executes rpm2deb-change:
    case $DEBUG in
    1)
        ./rpm2deb-change -v "$@" "testinput/$FILE" "testoutput/${FILE%s}log"
        ;;
    2)
        ./rpm2deb-change -d "$@" "testinput/$FILE" "testoutput/${FILE%s}log"
        ;;
    *)
        ./rpm2deb-change "$@" "testinput/$FILE" "testoutput/${FILE%s}log" > /dev/null
    esac
    
    # Remove date:
    sed -e 's/^\( -- .* <.*>\)  .*$/\1/' "testoutput/${FILE%s}log" > "testoutput/$CASE/output/${FILE%s}log"
}

# Generate expected result file:
#   $1: testcase
#   $2: testfile
#   $@: options of rpm2deb-change
function genResult() {
    local CASE
    local FILE
    
    # Arguments processing:
    CASE=$1
    shift
    FILE=$1
    shift
    
    # rpm2deb-change options processing:
    PACKAGE="$DEFAULT_PACKAGE"
    VERSION="$DEFAULT_VERSION"
    DISTRIBUTION="$DEFAULT_DISTRIBUTION"
    URGENCY="$DEFAULT_URGENCY"
    MAINTAINER="$DEFAULT_MAINTAINER"
    while [ $# -gt 0 ]; do
        case $1 in
        -d|--debug)
            ;;
        -v|--verbose)
            ;;
        -p|--package-name)
            shift
            PACKAGE="$1"
            ;;
        -m|--maintainer)
            shift
            MAINTAINER="$1"
            ;;
        -n|--newversion)
            shift
            VERSION="$1"
            ;;
        -a|--area)
            shift
            DISTRIBUTION="$1"
            ;;
        -u|--urgency)
            shift
            URGENCY="$1"
            ;;
        *)
            echo -e "\033[1;31mUnrecoginized option:$1\033[0m"
            exit 1
        esac
        shift
    done

    # Generate expected result file from tempate:
    [ -f "results/$CASE/$FILE" ] && sed -e "s/%PACKAGE%/$PACKAGE/" \
                                        -e "s/%VERSION%/$VERSION/" \
                                        -e "s/%AREA%/$DISTRIBUTION/" \
                                        -e "s/%URGENCY%/$URGENCY/" \
                                        -e "s/%MAINTAINER%/$MAINTAINER/" \
                                        "results/$CASE/$FILE" > "testoutput/$CASE/results/$FILE"
}


[ -d testinput ] || exit 1

# Execute test using options provided on the command line:
if [ $# -ge 1 ]; then
    [ ! -d testoutput ] || rm -R testoutput
    mkdir -p testoutput/create/{results,output} 
    mkdir -p testoutput/append/{results,output} 

    for FILE in $(ls testinput); do
        if [ -z $SELECTED_FILE -o $FILE == $SELECTED_FILE ]; then
            echo "Executing case 'create' with options '$*' on testfile '$FILE'"
            genOutput 'create' "${FILE}" "$@"
            genResult 'create' "${FILE%s}log" "$@"
            
            echo "Executing case 'append' with options '$*' on testfile '$FILE'"
            genOutput 'append' "${FILE}" "$@"
            genResult 'append' "${FILE%s}log" "$@"
        fi
    done

    for DIR in $(ls testoutput); do
        if [ -d "testoutput/$DIR" ]; then
            DIFF_OUTPUT=$(diff --unified=0 --recursive --new-file testoutput/$DIR/{results,output})
            if [ $? -gt 0 ]; then
                echo -e "\033[1;31mTest '$DIR' with options '$*' failed\033[0m"
                echo "$DIFF_OUTPUT" | grep -v ^diff
                exit 0
            else
                echo -e "\033[1;32mTest '$DIR' with options '$*' passed\033[0m"
            fi
        fi
    done
    
    exit 0
fi

# Execute test with default options set:
while IFS='' read -r OPTS; do
    [ ! -d testoutput ] || rm -R testoutput
    mkdir -p testoutput/create/{results,output} 
    mkdir -p testoutput/append/{results,output} 

    for FILE in $(ls testinput); do
        if [ -z "$SELECTED_FILE" -o "$FILE" == "$SELECTED_FILE" ]; then
            echo "Executing case 'create' with options '$OPTS' on testfile '$FILE'"
            genOutput 'create' "${FILE}" $OPTS
            genResult 'create' "${FILE%s}log" $OPTS
            
            echo "Executing case 'append' with options '$OPTS' on testfile '$FILE'"
            genOutput 'append' "${FILE}" $OPTS
            genResult 'append' "${FILE%s}log" $OPTS
        fi
    done

    for DIR in $(ls testoutput); do
        if [ -d "testoutput/$DIR" ]; then
            DIFF_OUTPUT=$(diff --unified=0 --recursive --new-file testoutput/$DIR/{results,output})
            if [ $? -gt 0 ]; then
                echo -e "\033[1;31mTest '$DIR' with options '$OPTS' failed\033[0m"
                echo "$DIFF_OUTPUT" | grep -v ^diff
                exit 0
            else
                echo -e "\033[1;32mTest '$DIR' with options '$OPTS' passed\033[0m"
            fi
        fi
    done
done  << EOD

-p devscripts-changelog
-n 18.18
-a testing
-u high
EOD

# Execute test with maintainer and default options set:
while IFS='' read -r OPTS; do
    [ ! -d testoutput ] || rm -R testoutput
    mkdir -p testoutput/create/{results,output} 
    mkdir -p testoutput/append/{results,output} 

    for FILE in $(ls testinput); do
        if [ -z "$SELECTED_FILE" -o "$FILE" == "$SELECTED_FILE" ]; then
            echo "Executing case 'create' with options '$OPTS -m \"Pascom <pascal_combes@laposte.net>\"' on testfile '$FILE'"
            genOutput 'create' "${FILE}" $OPTS -m "Pascom <pascal_combes@laposte.net>"
            genResult 'create' "${FILE%s}log" $OPTS -m "Pascom <pascal_combes@laposte.net>"
            
            echo "Executing case 'append' with options '$OPTS -m \"Pascom <pascal_combes@laposte.net>\"' on testfile '$FILE'"
            genOutput 'append' "${FILE}" $OPTS -m "Pascom <pascal_combes@laposte.net>"
            genResult 'append' "${FILE%s}log" $OPTS -m "Pascom <pascal_combes@laposte.net>"
        fi
    done

    for DIR in $(ls testoutput); do
        if [ -d "testoutput/$DIR" ]; then
            DIFF_OUTPUT=$(diff --unified=0 --recursive --new-file testoutput/$DIR/{results,output})
            if [ $? -gt 0 ]; then
                echo -e "\033[1;31mTest '$DIR' with options '$OPTS -m \"Pascom <pascal_combes@laposte.net>\"' failed\033[0m"
                echo "$DIFF_OUTPUT" | grep -v ^diff
                exit 0
            else
                echo -e "\033[1;32mTest '$DIR' with options '$OPTS -m \"Pascom <pascal_combes@laposte.net>\"' passed\033[0m"
            fi
        fi
    done
done  << EOD

-p devscripts-changelog
-n 18.18
-a testing
-u high
EOD
