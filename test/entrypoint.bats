#!/usr/bin/env bats

PATH="$PATH:$BATS_TEST_DIRNAME/bin"

function setup() {
  # Ensure GITHUB_WORKSPACE is set
  export GITHUB_WORKSPACE="${GITHUB_WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

@test "entrypoint runs successfully" {
  run $GITHUB_WORKSPACE/entrypoint.sh --help
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "PROJECT_ID selects the project without interactive --add" {
  export FIREBASE_TOKEN="test-token"
  export PROJECT_ID="demo-project"
  export PATH="$BATS_TEST_DIRNAME/bin:$PATH"
  export FIREBASE_MOCK_LOG="${BATS_TMPDIR}/firebase-mock.log"
  rm -f "$FIREBASE_MOCK_LOG"

  run "$GITHUB_WORKSPACE/entrypoint.sh" projects:list
  echo "$output"
  [ "$status" -eq 0 ]
  grep "use demo-project" "$FIREBASE_MOCK_LOG"
  run grep -- "--add" "$FIREBASE_MOCK_LOG"
  [ "$status" -ne 0 ]
}
