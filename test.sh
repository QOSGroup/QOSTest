#!/bin/bash

source ~/qos/test/metrics.sh
source ~/qos/test/batch_test/batch_test.sh
source ~/qos/test/random_test/random_test.sh

# init
update_all_metrics "print-on"

# random test
# random_test 100

# batch_test
batch_test

