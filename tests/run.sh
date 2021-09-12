#!/bin/bash

function test_input_file {
  output=$(perl ./human-genome-assembly-converter.pl -s GRCh38 -t GRCh37 --format BED -f tests/input.bed)
  expected_output=$(echo -e 'HG905_PATCH 75000 80000\n10 70936 71781\n10 71784 72184\n10 72185 73544\n10 73546 75937\nHG905_PATCH 75000 80000\n10 70936 71781\n10 71784 72184\n10 72185 73544\n10 73546 75937')
  if [[ $output == $expected_output ]] ; then 
      echo 'test_input_file: PASSED';
  else
      echo 'test_input_file: FAILED';
      echo -e $output
  fi
}

function test_bed_format {
  output=$(perl ./human-genome-assembly-converter.pl -s GRCh38 -t GRCh37 --format BED 10 25000 35000)
  expected_output=$(echo -e 'HG905_PATCH 75000 80000\n10 70936 71781\n10 71784 72184\n10 72185 73544\n10 73546 75937\n')
  if [[ $output == $expected_output ]] ; then 
      echo 'test_bed_format: PASSED';
  else
      echo 'test_bed_format: FAILED';
      echo -e $output
  fi
}

function test_json_format {
  output=$(perl ./human-genome-assembly-converter.pl -s GRCh38 -t GRCh37 10 25000 35000)
  expected_output='HG905_PATCH 75000 80000\n10 70936 71781\n10 71784 72184\n10 72185 73544\n10 73546 75937\n'
  if [[ $output == $expected_output ]] ; then 
      echo 'test_json_format: PASSED';
  else
      echo 'test_json_format: FAILED';
      echo -e $output
  fi
}

test_bed_format
test_json_format
test_input_file
