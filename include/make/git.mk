#!/usr/bin/env make
.PHONY: get_latest_commit_hash
get_latest_commit_hash:
	GIT_OPTIONS="--short HEAD" $(MAKE) _git_rev-parse > version

.PHONY: _git_%
_git_%: GIT_ACTION=$(shell echo "$@" | cut -f3 -d _)
_git_%:
	echo "Executing: git $(GIT_ACTION)" >&2
	docker run -t -v $$PWD:/work -w /work \
		-e MAKE_IS_RUNNING=true \
		alpine/git $(GIT_ACTION) $(GIT_OPTIONS)
