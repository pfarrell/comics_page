#! /usr/bin/env bash

year=$1
month=$2
rng_st=$3
rng_end=$4

for (( i=$rng_st; i<=$rng_end; i++ ))
do
  echo $year-$month-$i
  bundle exec ruby ./gather.rb $year-$month-$i
done

