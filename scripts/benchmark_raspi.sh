#!/bin/bash

PERF_SIZE="6GB"
STREAM_SIZE="6GB"
NUM_THREADS=4

# Generate thread counts: 1, 2, 4, ..., NUM_THREADS (even if not power of 2)
generate_thread_list() {
  local max=$1
  local i=1
  local list=()

  while (( i <= max )); do
    list+=($i)
    (( i *= 2 ))
  done

  # Add NUM_THREADS if it's not a power of 2 already
  if [[ "${list[@]}" != *" $max "* && "${list[-1]}" -ne "$max" ]]; then
    list+=($max)
  fi

  echo "${list[@]}"
}

THREAD_LIST=$(generate_thread_list "$NUM_THREADS")

echo "Test, Type, Value" > data_benchmark.csv

# STREAM benchmarks
benchmarks=("copy" "store" "store_neon" "triad" "triad_neon" "triad_neon_fma" "load" "load_neon")
for bench in "${benchmarks[@]}"; do
  for i in $THREAD_LIST; do
    output=$(likwid-bench -t "$bench" -w N:$STREAM_SIZE:$i)
    result=$(echo "$output" | grep "MByte/s:" | awk '{print $2}')
    if [[ -n "$result" ]]; then
      echo "stream, $bench, $i, $(echo "$result * 1000000" | bc)" >> data_benchmark.csv
    else
      echo "stream, $bench, $i, 0" >> data_benchmark.csv
    fi
  done
done

# PEAKFLOPS double precision
peakflops_tests=("peakflops" "peakflops_fma" "peakflops_neon" "peakflops_neon_fma")
for test in "${peakflops_tests[@]}"; do
  for i in $THREAD_LIST; do
    output=$(likwid-bench -t "$test" -w N:$PERF_SIZE:$i)
    result=$(echo "$output" | grep "MFlops/s:" | awk '{print $2}')
    if [[ -n "$result" ]]; then
      echo "peakflops_dp, $test, $i, $(echo "$result * 1000000" | bc)" >> data_benchmark.csv
    else
      echo "peakflops_dp, $test, $i, 0" >> data_benchmark.csv
    fi
  done
done

# PEAKFLOPS single precision
peakflops_tests=("peakflops_sp" "peakflops_sp_fma" "peakflops_sp_neon" "peakflops_sp_neon_fma")
for test in "${peakflops_tests[@]}"; do
  for i in $THREAD_LIST; do
    output=$(likwid-bench -t "$test" -w N:$PERF_SIZE:$i)
    result=$(echo "$output" | grep "MFlops/s:" | awk '{print $2}')
    if [[ -n "$result" ]]; then
      echo "peakflops_sp, $test, $i, $(echo "$result * 1000000" | bc)" >> data_benchmark.csv
    else
      echo "peakflops_sp, $test, $i, 0" >> data_benchmark.csv
    fi
  done
done

