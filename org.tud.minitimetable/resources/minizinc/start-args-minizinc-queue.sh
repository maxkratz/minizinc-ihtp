#!/bin/bash

#
# This script can be used to run the MiniZinc-based, IHTC/IHTP
# solution via tsp.
#
# @author Maximilian Kratz (maximilian.kratz@es.tu-darmstadt.de)
#

# set -e

# Which model to use
modelFile="./resources/minizinc/gips/AllConstraints.mzn"
# Gurobi parameter file. MiniZinc does not support all Gurobi parameter, like the NoRelHeur
gurobiParam="./resources/minizinc/Gurobi.prm"
# Minizinc folder or binary: please note that the app will search the entire directory tree to locate the binary.
miniZincDir="/opt/minizinc/MiniZincIDE-2.10.0-bundle-linux-x86_64"
# Global time limit
timelimit_all=7200
# MILP solving time limit
timelimit_solver=3600
# Number of threads to be used by Gurobi
threads=32

# Data input folder will be read from the first parameter (e.g., ./ihtc)
dataFolder=$1
# Run ID will be read from the second parameter (e.g., 01 for the first run)
RUN_ID=$2
# Instance number (e.g., 01 for the first instance)
i=$3

# Data file path will be constructed based on the given base path and $i
dataFile="$dataFolder/i$i.json"

outDir="./out/i${i}-${RUN_ID}/"
mkdir -p "$outDir"

ARGS=(
    "-m" "$modelFile"
    "-e" "$miniZincDir"
    "-gP" "$gurobiParam"
    "-d" "$dataFile"
    "-o" "$outDir"
    "-sts" "$timelimit_solver"
    "-ts" "$timelimit_all"
    "-p" "$threads"
)

echo ">>> Processing: $dataFile (Run: $RUN_ID)"
START=$SECONDS

# O1 is the optimization level
java -jar ./MiniZincRunner.jar "${ARGS[@]}" -O1 2>&1 | tee "$outDir/run.log" || {
    echo "ERROR after $((DURATION/3600))h $(( (DURATION%3600)/60 ))m $((DURATION%60))s at $dataFile!"
    exit 1
}

DURATION=$(( $SECONDS - $START ))
echo "Finished in $((DURATION/3600))h $(( (DURATION%3600)/60 ))m $((DURATION%60))s"

TOTAL_DURATION=$(( SECONDS - TOTAL_START ))

echo "-------------------------------------------"
echo "All files processed"
echo "Total Time:: ${TOTAL_DURATION}s"
