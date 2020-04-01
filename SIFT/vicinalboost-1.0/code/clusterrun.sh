#!/bin/bash

# This script runs several experiments in parallel on a cluster of
# computers.

case $1 in
    faces_haar)
	tasks_range=$(seq 1 105)
	script=$1
	;;

    shapes_haar)
	tasks_range=$(seq 1 210)
	script=$1
	;;

    faces_basic)
	tasks_range=$(seq 1 126)
	script=$1
	;;

    shapes_basic)
	tasks_range=$(seq 1 252)
	script=$1
	;;
    
    faces_full)
	tasks_range=$(seq 1 12)
	script=$1
	;;

    faces_test|shapes_test)
	tasks_range=$(seq 1 60)
	script=$1
	;;

    *)
	echo Experiment \"$1\" unknown!
	exit 1 ;
	;;
esac

nodes=({slim,slam,slim,slam,slim,slam,slim,slam,slim,slam,thel,golem,loew,thel,golem,loew,sand}.cs.ucla.edu)

#nodes=({slim,slam,slim,slam,golem,thel,loew,sand,sefer}.cs.ucla.edu)

# compute the duration of a task
function task_duration
{
    local st
    local et
    local i
    local hours
    local mins
    local secs
    local d
    i=$1
    st=tasks_started[$i]
    et=tasks_ended[$i]
    d=$(($et - $st))
    if (( $d < 0 )) ; then
	echo ...
	return
    fi
    hours=$(( $d / 3600 ))
    mins=$(( ($d - 3600 * $hours) / 60 ))
    secs=$(( ($d - 3600 * $hours - 60 * $mins) ))
    printf "%02d:%02d:%02d" $hours $mins $secs
}

function print_tasks_list
{
    local i ;
    printf "%7s%7s%7s%10s\n" Task Node Job Duration
    for ((i = 0 ; i < ${#tasks_job[@]} ; i += 1)) ; do
	printf "%7d" ${tasks_id[$i]}
	printf "%7d" ${tasks_node[$i]}
	printf "%7d" ${tasks_job[$i]}
	printf "%10s" `task_duration $i`
	echo
    done
}

function print_waiting_list
{
    local n ;
    for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
	echo " - node ${n} (${nodes[$n]}) waiting for job ${nodes_job[$n]}"
    done
}

function free_completed_nodes
{
   local n ;
   local j ;
   local job_list ;
   local has_stopped ;
   local compl_task_id ;
   local compl_task_ended ;
   
   # free nodes that ended
   job_list=`jobs -p -r`
   #echo "$job_list"
   for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
       check_job=${nodes_job[$n]} ;

       # if node is not waiting, skip
       if [ $check_job = 0 ] ; then continue ; fi

       # make sure that the node is not here
       has_stopped=1 ;
       for j in $job_list ; do	   
	   if [ "$j" = "$check_job" ] ; then
	       has_stopped="" ;
	   fi
	#   echo checking $j in $check_job results $has_stopped
       done
       
       if [ "$has_stopped" ] ; then	   


	   echo "Node ${n} (${nodes[$n]}) completed job ${check_job}"
	   compl_task_id=${nodes_task_id[$n]}
	   compl_task_index=${nodes_task_index[$n]}
	   tasks_ended[$compl_task_index]=`date +%s`

	   echo -n "Task ${compl_task_id} (idx ${compl_task_index}) "
	   echo -n "completed on node ${n} "
	   echo    "(${nodes[$n]}) as job ${nodes_job[$n]}"

	   nodes_job[$n]=0
	   nodes_task_id[$n]=0

	   if [ $1 ] ; then
	       print_tasks_list ;
	   fi
       fi
   done
}


# cleanup porperly if interupted
function onexit()
{
    for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
	if ((${nodes_job[$n]} == 0)) ; then
	    continue ;
	fi
	echo Signaling SIGINT to ${nodes_job[$n]}
	kill -s SIGINT ${nodes_job[$n]} 
    done
    sleep 5
    for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
	if ((${nodes_job[$n]} == 0)) ; then
	    continue ;
	fi	
	echo Signaling SIGTERM to ${nodes_job[$n]}
	kill -s SIGTERM ${nodes_job[$n]} 
    done
    exit ;
}

trap onexit 1 2 3 15 ERR
set -b

# init node related variables
for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
    nodes_job[$n]=0 ;
    nodes_task_id[$n]=0 ;
done

echo nodes: ${nodes[@]}
echo tasks: ${range_i}

# remove logs
rm -f log/${script}.*
rm -f results/${script}-*.mat

task_index=0 ;
for task_id in $tasks_range ; do
    
    # look for an available node
    echo "Watining for a node to finish. Waiting list: "
    print_waiting_list ;

    use_node=-1 ;
    while ((1)) ; do
	# is one of these available?
	for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
	    if ((${nodes_job[$n]} == 0)) ; then
		use_node=${n} ;
		break ;
	    fi
	done
	
	#  if found, stop here
	if ((${use_node} >= 0)) ; then break ; fi ;

	# unfortunately wait waits for _all_ jobs... so we poll instead
	sleep 5

	# free all nodes that are completed
	free_completed_nodes ;
    done
    
    sfx=$(printf "%04d" ${task_id})
    root_dir=$(pwd)
    ssh ${nodes[$n]} -t -t <<EOF > log/${script}.${sfx} 2>&1 &
cd ${root_dir} ;
time -p matlab -nojvm -nodisplay <<DONE
try
  ex_cluster_job_id=${task_id};
  addpath experiments ;
  ${script} ;
catch
  disp(lasterror);
  exit ;
end
exit ;
DONE
exit ;
EOF
    nodes_job[$n]=$!
    nodes_task_id[$n]=$task_id
    nodes_task_index[$n]=$task_index

    tasks_id[$task_index]=$task_id
    tasks_job[$task_index]=${nodes_job[$n]}
    tasks_node[$task_index]=$n
    tasks_started[$task_index]=`date +%s`
    tasks_ended[$task_index]=0

    echo -n "Task ${task_id} (idx ${task_index}) started on node ${n} "
    echo    "(${nodes[$n]}) as job ${nodes_job[$n]}"
    print_tasks_list ;
    
    task_index=$((${task_index} + 1))
done
    
# now wait for the last active jobs to complete
while true ; do    
    all_done=1 ;
    for ((n = 0 ; n < ${#nodes[@]} ; n += 1)) ; do
	if ((${nodes_job[$n]} != 0)) ; then
	    all_done="" ;
	fi
    done
    
    # if not found, stop here
    if [ $all_done ] ; then break ; fi ;
    
    sleep 5
    
    free_completed_nodes 1 ;
done

echo "All completed. Leaving."
