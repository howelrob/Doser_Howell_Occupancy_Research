#!/usr/bin/bash
#
# Script:  02_submit.sh
# Usage: For submitting multiple batch jobs to the NCSU HPC.
# Author: Jeffrey W. Doser (adapted from NCSU HPC)
#
# To run, type:
#     ./02_submit.sh [start_row end_row replicates] 
#  Script must have execute permissions, i.e.,
#     chmod u+x 02_submit.sh

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
  
  bsub -n 1 -W 7200 -R span[hosts=1] -R "rusage[mem=5]" -q cnr -oo out.02_main_test.$start_row -eo err.02_main_test.$start_row "Rscript 02_main.R $start_row $reps"

  ((start_row++))

done
