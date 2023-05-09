#!/usr/bin/env bash

set -e

ROOT=$(cd "$(dirname "$0")";pwd)

rm -rf dist
cnpm install
cnpm run build:release
scp -v -r ${ROOT}/dist/* root@ziji.fun:/ziji/project/ziji/public/
