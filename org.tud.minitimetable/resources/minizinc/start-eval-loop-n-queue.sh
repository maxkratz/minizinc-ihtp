#!/bin/bash

#
# This script can be used to execute the MiniZinc-based solution for all of the IHTC 2024 instances `n` times.
#
# It assumes that in the current directory there is a folder called
# `resources/input/ihtc` containing all instance files.
#
# Example: `./start-eval-loop-n-queue.sh $numberOfRepetitions
#                                        3
#                                        $1
#
# If you have any questions, feel free to write us an email.
#
# @author Maximilian Kratz (maximilian.kratz@es.tu-darmstadt.de)
#

# # Disable OOM killer on system level
echo "# Disable OOM killer on system level."
sudo bash -c 'echo 2 > /proc/sys/vm/overcommit_memory'
sudo bash -c 'echo 99 > /proc/sys/vm/overcommit_ratio'

# Configuration taken by the arguments
export repetitions=$1

if [ -z "$repetitions" ]; then
    echo "# Script error: Missing parameter for repetitions."
    exit 1
fi

function create_job {
    ./ts-helper.sh \
        add \
        ./start-args-minizinc-queue.sh \
            $1 \
            $2 \
            $3
}

function expand {
    if [ $1 -lt 10 ]; then
        echo "0$1"
    else
        echo "$1"
    fi
}

echo "#"
echo "# => Repetition queuing script start."
echo "# Number of repetitions: ${repetitions}."
echo "#"

# Do for $repetitions number of repetitions
for ((r=1;r<=${repetitions};r++));
do
    # Output folder of this repetition's run will be created below

    # Do for all 30 instances
    for ((i=1;i<=30;i++));
    do
        # Create output folder for this $i
        iexp=$(expand $i)
        rexp=$(expand $r)

        # Schedule job
        create_job \
            "./resources/input/ihtc" \
            "$rexp" \
            "$iexp"
    done
done

echo "#"
echo "# => Repetition queuing script done."
echo "#"
