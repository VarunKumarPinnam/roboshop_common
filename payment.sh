#!/bin/bash
app_name=payment

source ./common.sh

check_root
app_setup
python_steup
systemd_setup
total_execution_time