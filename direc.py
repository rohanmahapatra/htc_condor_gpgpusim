#!/usr/bin/python
import os
import re

folder = '/home/rmahapatra/projects_tlb/gpgpu-sim-v2_tlb/condor_workdir/benchmarks_hw2/sweep_test_final/runs_all'

res = "final_results"
command5 = "mkdir " + res
os.system(command5)
command4  = "rm " + res + "_grep.txt"
os.system(command4)
count = 0
for dirname, dirs, files in os.walk(folder):
    for directories in dirs:
	#print (directories)
	if (re.search("result", directories)):
		dir_path = dirname + "/" + directories
		listOfFiles = os.listdir(dir_path)
		for f in listOfFiles:
			if (re.search("out", f)):
				dir_name = dirname.split("/")
				result_fname = dir_name[-1]
				result_fname = result_fname.split("_")
				log_fname = result_fname[1] + '-' + "results" + '-' + result_fname[0] + ".txt"
				#print log_fname
				#print files
				#print dirname,directories
				log_fname_path = dirname + "/" + directories + "/" + f
				#print log_fname_path
				command1 = "cp -f " + log_fname_path  + " " + res + "/" + log_fname
				#print command1
				#os.system("cp -f log_fname_path final_results/")
				command2 = "grep -ri gpu_tot " + log_fname_path + " | tail -6" + ">>" + res + "_grep.txt"
				command3 = "echo " + log_fname_path + ">>" + res + "_grep.txt"
				os.system(command3)
				os.system(command2)
				os.system(command1)

			if (re.search("err",f)):
				#print "error", f
				err_fname_path = dirname + "/" + directories + "/" + f
				#print err_fname_path
				if os.stat(err_fname_path).st_size != 0:
					print "Error in test:", err_fname_path
