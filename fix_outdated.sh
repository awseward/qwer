#!/usr/bin/env bash

set -euo pipefail

>&2 cat <<-ERR
---
ERROR: Support for "fix outdated" is currently not available
       I'm not really even sure whether it's even a use-case that is worth
       supporting to be completely frank…
---
ERR

exit 1
