#!/usr/bin/env bash

# Copyright 2023 Google LLC All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

: "${GIT_HASH:?Environment variable empty or not defined.}"
: "${GIT_TAG:?Environment variable empty or not defined.}"
: "${RUN_ID:?Environment variable empty or not defined.}"
: "${RUN_ATTEMPT:?Environment variable empty or not defined.}"
: "${REGISTRY:?Environment variable empty or not defined.}"

echo "Signing images with Keyless..."
digest=$(crane digest "${REGISTRY}"/ko:"${GIT_TAG}")
cosign sign --yes \
    -a GIT_HASH="${GIT_HASH}" \
    -a GIT_TAG="${GIT_TAG}" \
    -a RUN_ID="${RUN_ID}" \
    -a RUN_ATTEMPT="${RUN_ATTEMPT}" \
    "${REGISTRY}/ko@${digest}"
