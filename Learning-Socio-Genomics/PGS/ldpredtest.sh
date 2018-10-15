#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=00:01:00
#SBATCH --job-name=ldtest
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail@email.com
module purge
module load python/2.7
export PYTHONPATH=$PYTHONPATH:/system/software/linux-x86_64/lib/libplinkio/0.3.1/lib/python2.7/site-packages
python ldpred/coord_genotypes.py --gf=test_data/LDpred_data_p0.001_test_0 --ssf=test_data/LDpred_data_p0.001_ss_0.txt --N=100 --out=bogus.hdf5
python ldpred/LDpred.py --coord=bogus.hdf5 --ld_radius=1 --PS=0.3 --N=100 --out=ldpredoutput
python ldpred/validate.py --vgf=test_data/LDpred_cc_data_p0.001_train_0 --rf=ldpredoutput --out=pgsoutputs
