# setup

Connect with user1 or user2

`ssh user1@206.12.89.223`

Three things are required : 
- project code for the training
- dataset for the training  
- sbatch script to start the training

Copy the project used by narval (vs github)

```
ssh user1@206.12.89.223
cd projects/def-sponsor00/user1/
mkdir tests
cd tests
scp vincelf@narval.computecanada.ca:/home/vincelf/projects/def-germ2201-ab/vincelf/tests/narval-training.tar.gz .
tar -xvf narval-training.tar.gz
cd drone-des-champs-ai-salad/
python -m venv .venv
source ./.venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI
```

Copy the dataset used by narval 

```
scp vincelf@narval.computecanada.ca:/home/vincelf/scratch/2020_DEFLAND_SOLVI-whole50m-224x224-training-10963.tar /home/user1/scratch
```

Adapt the sbatch script to Magic Castle 

scripts/sh/training/start_training_magiccastle_1gpu.sh
``` 
###############################################################################
# use command 'partition-stats' to check availabilities
#SBATCH --time=0-09:00
#SBATCH --output=%N-%j.out
#SBATCH --account=def-sponsor00 # already set in .bashrc
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-gpu=8G
###############################################################################

# module load python/3.7 no need as virutal env already installed

SOURCEDIR=/project/def-sponsor00/user1/tests/drone-des-champs-ai-salad
cd $SOURCEDIR

source .venv/bin/activate

# check python version
python --version
which python

# prepare dataset
mkdir -p $SLURM_TMPDIR/data
tar -xvf ~/scratch/2020_DEFLAND_SOLVI-whole50m-224x224-training-10963.tar -C $SLURM_TMPDIR/data

# start training
date
python $SOURCEDIR/src/tv-training-code.py $SLURM_TMPDIR/data/2020_DEFLAND_SOLVI-whole50m-224x224/training
date
```

Start the training
```
sbatch scripts/sh/training/start_training_magiccastle_1gpu.sh
```
