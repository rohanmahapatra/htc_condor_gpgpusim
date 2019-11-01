#kill processes if we get ctrl-c
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
basedir="run_baseline"

pids=()
#declare -a configs=("faTLB-128entry-40lat")
#declare -a configs=("faTLB-128entry-20lat" "faTLB-128entry-40lat" "faTLB-64entry-20lat" "8wayTLB-128entry-20lat" "8wayTLB-128entry-40lat" "8wayTLB-64entry-20lat")
#declare -a configs=("faTLB-128entry-20lat_1")
declare -a benchmark_dir=("bfs_baseline" "backprop_baseline" "nw_baseline" "nn_baseline" "bc_baseline" "hotsp_baseline" "pagerank_baseline")
declare -a benchmarks=("bfs" "backprop" "nw" "nn" "bc" "hotsp" "pagerank")
#declare -a benchmarks=("bfs" "backprop" "nw" "nn" "bc" "hotsp" "pagerank")
#declare -a benchmarks=("backprop" "nw" "nn" "bc" "hotsp" "pagerank")
#declare -a benchmarks=("backprop")

for benchmark in ${benchmarks[@]}
do
        # create the run folder
        mkdir -p ${basedir}/${benchmark_dir}

        # copy the benchmark over
        cp -r ${benchmark}/* ${basedir}/${benchmark_dir}

        # grab the right config files
        cp configs/config_volta_islip.icnt ${basedir}/${benchmark_dir}/config_volta_islip.icnt
        cp configs/gpgpusim.config ${basedir}/${benchmark_dir}/gpgpusim.config

        # cd to the right directory, run the test with redirected output, save its pid
        cd ${basedir}/${benchmark_dir}
        echo "starting ${benchmark}"
        # run condor job
        mkdir SM7_TITANV-results
    	echo "...................... Launching Job: ${benchmark}.sub ....................... "
        
	#condor_submit ${benchmark}_baseline.sub
    	echo ".............................. *********  .................................... "
        pids+=($!)

        # cd back to the launchdir
 	cd ${launchdir}

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
#       for config in ${configs[@]}
#       do
#               grep -i "gpu_tot_sim_cycle" ${basedir}/${now}/${config}_${benchmark}/logfile | sed -e 's/^/${config} /' >> ${basedir}/${now}/${benchmark}_stats
#       done
#done

# ring bell
tput bel
echo "done"
