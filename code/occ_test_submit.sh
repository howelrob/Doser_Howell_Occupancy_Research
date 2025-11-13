#!/usr/bin/bash
#
# Script:  occ_test_submit.sh
# Usage: For submitting multiple batch jobs to the NCSU HPC.
# Author: Jeffrey W. Doser (adapted from NCSU HPC)
#
# To run, type:
#     ./occ_test_submit.sh [start_row end_row replicates] 
#  Script must have execute permissions, i.e.,
#     chmod u+x occ_test_submit.sh

module load openmpi-gcc
module load R

# Some quick checks
if [ $# -ne 3 ]; then
        echo "Usage: You need to feed three arguments to this program which are"
        echo "the start and end row of the parameters, and the number of replicates. For example,"
        echo "./occ_research_submit.sh 1 40 10"
        exit 1
fi


#Read in variables
start_row=$1
end_row=$2
reps=$3



#2) Call the main script once from here, give it the start end and rows and do the loop in the
# main script



# Output printed to the screen
while [ $start_row -le $end_row ]
do 

  echo "Submit job = row:$start_row, replicates:$reps"
  
  # This is the line of code that submits the script to the NCSU HPC. 
  # -n: 1 core
  # -W: allow it to run for 7200 minutes (if needed) before stopping 
  # -R: realted to multi-threading on a single core, just using 1. We also tell how much memory we request for each core. 
  # -q cnr: this is the specific queue we use which gives us priority when running on the HPC. 
  # -oo name of the output file.
  # -eo name of the error output file. 
  bsub -n 1 -W 7200 -R span[hosts=1] -R "rusage[mem=10]" -q cnr -oo out.02_main_test.$start_row -eo err.02_main_test.$start_row "Rscript 02_main.R $start_row $reps"

  ((start_row++))

done
