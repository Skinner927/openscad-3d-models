#!/usr/bin/env bash
# Re-export every printable part in parts/ to stl/, plus the mirrored
# stage set for port tower B. Runs the exports in parallel.
#   usage: ./export_stls.sh            (from anywhere)
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p stl

MIRRORED=(stage_base stage_x_slider stage_z_slider stage_z_cap)
fail=0
pids=()
names=()

export_one() {  # <out.stl> <in.scad> [extra openscad args...]
    local out=$1 in=$2; shift 2
    local log
    log=$(openscad "$@" -o "$out" "$in" 2>&1) || { echo "FAIL $out"; echo "$log" | tail -3; return 1; }
    if grep -qE "WARNING|ERROR" <<<"$log"; then
        echo "WARN $out"; grep -E "WARNING|ERROR" <<<"$log" | head -3
    else
        echo "ok   $out"
    fi
}

# Create image of the assembly. Don't add it to names so it doesn't count towards exports.
export_one assembly.png assembly.scad --camera='550,-240,400,0,-60,25' -D show_plywood=false &
pids+=($!)

# Export all parts
for f in parts/*.scad; do
    n=$(basename "$f" .scad)
    export_one "stl/$n.stl" "$f" & pids+=($!); names+=("$n")
done
for n in "${MIRRORED[@]}"; do
    export_one "stl/${n}_mirrored.stl" "parts/$n.scad" -D mirrored=true & pids+=($!); names+=("${n}_mirrored")
done
for p in "${pids[@]}"; do wait "$p" || fail=1; done

echo
if [ "$fail" -eq 0 ]; then
  echo "Exported ${#names[@]} STLs to $(pwd)/stl";
else
  echo "Some exports failed"; exit 1;
fi
