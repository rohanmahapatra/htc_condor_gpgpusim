#!/bin/bash

./bfs graph4096.txt > test_baserun.txt
mv gpgpusim.config gpgpusim.config.baserun

mv gpgpusim.config.faTLB-128entry-20lat gpgpusim.config
./bfs graph4096.txt > test_faTLB-128entry-20lat.txt 
mv gpgpusim.config gpgpusim.config.faTLB-128entry-20lat

mv gpgpusim.config.faTLB-128entry-40lat gpgpusim.config
./bfs graph4096.txt > test_faTLB-128entry-40lat.txt 
mv gpgpusim.config gpgpusim.config.faTLB-128entry-40lat

mv gpgpusim.config.faTLB-64entry-20lat gpgpusim.config 
./bfs graph4096.txt > test_faTLB-64entry-20lat.txt 
mv gpgpusim.config gpgpusim.config.faTLB-64entry-20lat

mv gpgpusim.config.8wayTLB-128entry-20lat gpgpusim.config 
./bfs graph4096.txt > test_8wayTLB-128entry-20lat.txt 
mv gpgpusim.config gpgpusim.config.8wayTLB-128entry-20lat 

mv gpgpusim.config.8wayTLB-128entry-40lat gpgpusim.config 
./bfs graph4096.txt > test_8wayTLB-128entry-40lat.txt 
mv gpgpusim.config gpgpusim.config.8wayTLB-128entry-40lat

mv gpgpusim.config.8wayTLB-64entry-20lat gpgpusim.config 
./bfs graph4096.txt > test_8wayTLB-64entry-20lat.txt 
mv gpgpusim.config gpgpusim.config.8wayTLB-64entry-20lat


grep -ri "tlb" test*txt > grep_results.txt
