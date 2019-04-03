#!/bin/bash
cd ${HOME}/git/afit_mlperf_training/recommendation

# Be sure to
#   conda activate pytorch-gpu
# before running
if [ "$CONDA_DEFAULT_ENV" != "pytorch-gpu" ]
then
	echo "Error: not in the correct conda environment."
	echo "  Be sure to run 'conda activate pytorch-gpu'"
	echo "  before running this script."
	exit 1
fi

for i in {1..100}
do
	# Run native
	echo "recommendation: native, run ${i}"
	bash pytorch/run_and_time.sh &> "$(hostname).$(date --date "now" +"%Y-%m-%d-%H-%M").native.log"

	# Run singularity
	# Note: need sudo on DL/ML boxes due to permission configuration on NAS.
	echo "recommendation: singularity, run ${i}"
	singularity exec \
		--nv \
		--bind $(pwd):/benchmark \
		--bind ${MLPERF_DATA_DIR}:/data \
		${SINGULARITY_CONTAINER_PATH}/recommendation.simg \
		/bin/bash  /benchmark/pytorch/run_and_time.sh &> "$(hostname).$(date --date "now" +"%Y-%m-%d-%H-%M").singularity.log"
done


