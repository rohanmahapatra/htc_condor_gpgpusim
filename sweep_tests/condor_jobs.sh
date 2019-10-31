# kill processes if we get ctrl-c
trap quit INT
function quit() {
    echo "quitting early and killing children..."
    for pid in ${pids[*]}; do
        kill $pid
    done
    exit
}

# get the time for folder name
now=$(date +"%m-%d-%Y_%H-%M")

launchdir=$PWD
basedir="runs"

pids=()
declare -a configs=("default" "tlb_1_128_20" "tlb_1_128_100" "tlb_1_128_200")
declare -a benchmarks=("bfs" "backprop" "nw" "nn")

for benchmark in ${benchmarks[@]}
do
    for config in ${configs[@]}
    do
        # create the run folder
        mkdir -p ${basedir}/${now}/${config}_${benchmark}

        # copy the benchmark over
        cp -r ${benchmark}/* runs/${now}/${config}_${benchmark}

        # grab the right config files
        cp configs/${config}.icnt ${basedir}/${now}/${config}_${benchmark}/config_volta_islip.icnt
        cp configs/${config}.config ${basedir}/${now}/${config}_${benchmark}/gpgpusim.config

        # cd to the right directory, run the test with redirected output, save its pid
        cd ${basedir}/${now}/${config}_${benchmark}
        echo "starting ${config}_${benchmark}"
	# run condor job
	mkdir results
    	echo ".....................  Launching Job: ${benchmark}.sub ................... \n\n"
	#condor_submit ${benchmark}.sub
	
        pids+=($!)

        # cd back to the launchdir
        cd ${launchdir}

    done
done

# wait for children to die -- is this even relevant here?
for pid in ${pids[*]}; do
    wait $pid
done

# open the logs
#for f in $(find runs | grep --color=auto errfile); do less $f; done
#for f in $(find runs | grep --color=auto logfile); do less $f; done

# aggregate relevant stats
#for benchmark in ${benchmarks[@]}
#do
#	for config in ${configs[@]}
#	do
#		grep -i "gpu_tot_sim_cycle" ${basedir}/${now}/${config}_${benchmark}/logfile | sed -e 's/^/${config} /' >> ${basedir}/${now}/${benchmark}_stats
#	done
#done

# ring bell
tput bel
echo "done"
