#!/usr/bin/env bash

task.docs() {
	shdoc < './pkg/src/bakeScript.sh' > './docs/api.md'
}
