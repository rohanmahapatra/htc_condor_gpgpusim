#1. Generates final_results_grep.txt with relevant stats
#2. Checks err log to ensure there were no errors during the run
#3. Copies all the GPGPU-Sim stat files from different run directories into final_results directory and renames the stat files adhering to HW2 submission file names

#This works if you used Devin's Script for HW1 to launch multiple jobs in condor creating separate directories for each job 
#!/usr/bin/python
import os
import re

folder = '<path to run directories>'

res = "final_results"
command5 = "mkdir " + res
os.system(command5)
command4  = "rm " + res + "_grep.txt"
os.system(command4)
count = 0
for dirname, dirs, files in os.walk(folder):
    for directories in dirs:
        if (re.search("result", directories)):
                dir_path = dirname + "/" + directories
                listOfFiles = os.listdir(dir_path)
                for f in listOfFiles:
                        if (re.search("out", f)):
                                dir_name = dirname.split("/")
                                result_fname = dir_name[-1]
                                result_fname = result_fname.split("_")
                                log_fname = result_fname[1] + '-' + "results" + '-' + result_fname[0] + ".txt"
                                log_fname_path = dirname + "/" + directories + "/" + f
                                command1 = "cp -f " + log_fname_path  + " " + res + "/" + log_fname
                                command2 = "grep -ri gpu_tot " + log_fname_path + " | tail -3" + ">>" + res + "_grep.txt"
                                command3 = "echo " + log_fname_path + ">>" + res + "_grep.txt"
                                os.system(command3)
                                os.system(command2)
                                os.system(command1)

                        if (re.search("err",f)):
                                err_fname_path = dirname + "/" + directories + "/" + f
                                if os.stat(err_fname_path).st_size != 0:
                                        print "Error in test:", err_fname_path
