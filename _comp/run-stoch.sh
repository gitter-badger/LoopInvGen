#!/bin/bash

TOOL_DIR="$HOME/Tools"
SELF_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

SYGUS_WITH_GRAMMAR_FILE="/tmp/stoch.$(basename $2).$(basename $1)"
SYGUS_NAME_MAPPING_FILE="/tmp/stoch.$(basename $2).$(basename $1).map"

"$SELF_DIR"/../_build/install/default/bin/transform \
  -a -c -r -s "$SYGUS_NAME_MAPPING_FILE" -t -g $2 $1 \
  > "$SYGUS_WITH_GRAMMAR_FILE"

sed -i 's/div\ /\/ /g' "$SYGUS_WITH_GRAMMAR_FILE"
sed -i 's/mod\ /modfn /g' "$SYGUS_WITH_GRAMMAR_FILE"

cd "$TOOL_DIR"/Stoch-SyGuS/lib
rm -rf ld-linux* libc* libgcc* libm* libpthread* librt* libstdc++*

cd ../bin
rm -rf log*

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib ./stoch "$SYGUS_WITH_GRAMMAR_FILE" > res
sed -i 's/\/ /div /g' res
sed -i 's/modfn\ /mod /g' res

while read -u 23 p ; do
  sed -i $p res
done 23< "$SYGUS_NAME_MAPPING_FILE"

cat log* >&2 ; cat res
