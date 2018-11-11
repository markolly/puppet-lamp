#!/bin/bash

# VARIABLES
STASH_NAME="pre-commit-$(date +%s)"

# FUNCTIONS
function log {
  printf "\n--- $1 ---\n"
}

function gitStash {
  # Stash unstaged changes before running tests
  git stash save -q --keep-index $STASH_NAME
  if [ "$?" -ne 0 ]; then
    log "GIT STASH FAILED"
    exit 1
  fi
}

function gitPopStash {
  FIND_STASH=$(git stash list | grep $STASH_NAME)
  if [ "$FIND_STASH" ]; then
    git stash pop -q stash@{0}
    if [ "$?" -ne 0 ]; then
      log "GIT STASH POP FAILED"
      exit 1
    fi
  fi
}

function rubocopTests {
  log "RUNNING RUBOCOP TESTS"
  rake rubocop
  if [ "$?" -ne 0 ]; then
    log "RUBOCOP TESTS FAILED"
    gitPopStash
    exit 1
  fi
}

function releaseTests {
  log "RUNNING RELEASE CHECKS TESTS"
  rake release_checks
  if [ "$?" -ne 0 ]; then
    log "RELEASE CHECKS FAILED"
    gitPopStash
    exit 1
  fi
}

# PROCESS
log "STARTING TEST HARNESS BUILD"
gitStash
rubocopTests
releaseTests
gitPopStash
log "TEST HARNESS FINISHED SUCCESSFULLY"
