#!/bin/bash
#
# This pre-commit hook runs test harness before commit.
# PASTE THIS FILE INTO .git/hooks/ IN YOUR REPOSITORY TO PREVENT UNSAFE COMMITS!

printf "\n--- PRE COMMIT HOOK START ---\n"
#Run test harness
bash scripts/testharness.sh

if [ $? -ne 0 ]; then
 printf "\n--- CODE IS NOT READY TO COMMIT ---\n"
 exit 1
fi

printf "\n--- PRE COMMIT HOOK FINISHED WITH SUCCESS ---\n"
