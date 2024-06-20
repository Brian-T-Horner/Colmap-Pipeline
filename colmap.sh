#!/bin/bash

#SBATCH --account=def-ycoady
#SBATCH --mem=178G
#SBATCH --time=09:59:00
#SBATCH --mail-user=horner.br@northeastern.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=2
#SBACTH --gpus-per-node=2
#SBATCH --gres=gpu:v100:1
#SBATCH --cpus-per-task=12
#SBATCH --output=run_colmap_%j.out\
#SBATCH --job-name=Colmap_Image_Processing_bhorner






function usage {
    echo ""
    echo "Process the given images with CUDA enabled Colmap, storing the resulting COLMAP files in the given output directory."
    echo ""
    echo "usage: $programname --images string --output string "
    echo ""
    echo "  --images string         the directory that contains the raw images to be processed by the COLMAP pipeline"
    echo " --output string 	    the directory that will contain the colmap output"
    echo "  --help                  displays this help"
    echo ""
}

function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}

#Load singularity
#module purge
module load singularity
#module load arch/avx512 StdEnv/2020


#module load StdEnv/2020 ucx/1.12.1
	
#module load  StdEnv/2020  gcc/11.3.0
#module load StdEnv/2020   ucx/1.8.0
#module load  StdEnv/2020  gcc/11.3.0  openmpi/4.1.4
#module load StdEnv/2020 ucx/1.12.1
#module load  StdEnv/2020  gcc/9.3.0
#module load  StdEnv/2020  intel/2020.1.217
#module load  StdEnv/2020  intel/2022.1.0
#module load  StdEnv/2020  intel/2022.1.0  openmpi/4.1.4
#module load  StdEnv/2020  nvhpc/22.1
#module load  StdEnv/2020  nvhpc/22.7

#module load gcc
#module load cuda/11.7
module load cuda
module load python/3.11.2


echo nvidia-smi

echo "Parsing commands now.."

#while [ $# -gt 0 ]
#do
 #   case $1 in
  #      --images)
   #         input_path=$2
   #         shift 2
   #         ;;
   #     --output)
   #         output_path=$2
   #         shift 2
   #         ;;
#	--container)
#	    colmap_container=$2
#	    shift 2
#	    ;;
 #       --help)
#	    usage
#	    exit 0
#	    ;;
 #        *)
#	    usage
#	    die "Error: Unrecognized option $1"
#	    ;;

 # esac

#done



#if [ -z "$input_path" ]
#then
#    usage
#    die "Missing required parameters --images"
#fi

#if [ -z "$output_path" ]
#then
#    usage
#    die "Missing required parameters --output"
#fi

#if [ -z "$colmap_container" ]
#then
#    colmap="home/bhorner/scratch/Colmap/colmap-cuda-11.7.sif"

#    if [ ! -e "$colmap_container" ]
#    then
#        die "Could not find the colmap container within the given path"
#    fi
#fi

echo "Commands accepted. Running container now."
colmap_container="$PWD/colmap-cuda-11.7"
input_path="$PWD/ECS"
output_path="$PWD/output"
#current_directory= "$PWD"
#Run container
singularity exec --bind $input_path:/opt/colmap-nu-papers/images \
--bind $output_path:/opt/colmap-nu-papers/output ${colmap_container} \
bash -c "cd /opt/colmap-nu-papers && python3 colmapPipeline.py images output"
