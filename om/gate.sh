#!/bin/sh
set -eu
OMC="${OMC:-/home/drakestapleton/canon/omega-mv/seed/out/omc}"
[ -x "$OMC" ] || { echo "NOT_RUN: set OMC to seed/out/omc"; exit 3; }
SCR=$(mktemp -d)
trap "rm -rf $SCR" EXIT

build_det() {
  name=$1; shift
  cat "$@" > "$SCR/$name.om"
  "$OMC" < "$SCR/$name.om" > "$SCR/$name.1" 2> "$SCR/$name.err" || { echo "FAIL compile $name"; cat "$SCR/$name.err"; exit 1; }
  "$OMC" < "$SCR/$name.om" > "$SCR/$name.2" 2>> "$SCR/$name.err" || { echo "FAIL compile2 $name"; exit 1; }
  cmp -s "$SCR/$name.1" "$SCR/$name.2" || { echo "FAIL nondeterministic $name"; exit 1; }
  chmod +x "$SCR/$name.1"
  echo "BUILD_OK $name bytes=$(wc -c < "$SCR/$name.1") sha256=$(sha256sum "$SCR/$name.1" | awk "{print \$1}")"
}

build_det cortex_server \
  om/om2.om om/f64.om om/uni_rust.om om/json.om om/crc32c.om om/uni_fts.om om/flog.om om/fts.om \
  om/like.om om/http.om om/store.om om/log.om om/api.om om/api2.om om/api3.om om/qs.om om/enc.om \
  om/de.om om/brain.om om/srv.om om/main.om

build_det cortex_import om/om2.om om/crc32c.om om/sqlite.om om/import_main.om

# Negative control: missing/bad CLI usage must exit nonzero cleanly (no crash)
if "$SCR/cortex_import.1" >/dev/null 2>&1; then
  echo "FAIL cortex_import accepted empty args"
  exit 1
fi
echo "CONTROL_OK cortex_import refused missing args"
echo "CORTEX-OM-GATE PASS"
