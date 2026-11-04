#!/usr/bin/env python3
"""Render every USB-robot OpenSCAD file and check it.

Run from anywhere:  python3 -I usb-robot/tests/run_tests.py

Per target:   exit code 0, no WARNING/ERROR on stderr, and (bed=True)
              the STL bounding box fits the 250 mm printer.
Echo checks:  any file may `echo("CHECK", "<name>", <value>);`.  EXPECT
              compares those values; a string value refers to another
              CHECK name.
Empty checks: MUST_BE_EMPTY files are collision intersections, so they
              must render to nothing at all.
"""
import os
import re
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BED = 250.0

# (file, bed_check). bed_check=False also tolerates the 2-manifold warning:
# the assembly unions separate parts that touch face-to-face by design.
TARGETS = [
    ("tests/fixtures/lib_smoke.scad", True),
    ("parts/stage_base.scad", True),
    ("parts/stage_x_slider.scad", True),
    ("parts/stage_z_slider.scad", True),
    ("parts/stage_z_cap.scad", True),
    ("parts/port_bracket.scad", True),
    ("parts/pinion.scad", True),
    ("tests/fixtures/rack_smoke.scad", True),
    ("parts/x_base.scad", True),
    ("parts/x_carriage.scad", True),
    ("parts/y_carriage.scad", True),
    ("parts/servo_holder.scad", True),
    ("parts/plug_flexure.scad", True),
    ("parts/plug_clamp_cap.scad", True),
    ("parts/plug_flex_stop.scad", True),
    ("parts/tower_jig.scad", True),
    ("assembly.scad", False),
]

# name -> (op, value, tol)   value may be a number or another CHECK name
EXPECT = {
    # D-hole flat edge: a real gap so the thread goes in, but no looser than
    # the original 0.4 mm (about +/-7 deg of twist with a 15 mm hole)
    "d_hole_flat": ("<=", 6.9, 1e-6),
    "d_hole_flat_gap": (">", 0, 1e-6),
    "stage_travel_x": (">=", 10, 1e-6),
    "stage_travel_z": (">=", 10, 1e-6),
    "x_travel_180": (">=", "x_travel", 1e-6),
    "y_travel_deg": ("<=", 90, 1e-6),
    "x_rail_len": ("<=", 240, 1e-6),
    "x_mesh_gap": ("==", 0, 0.05),
    "y_mesh_gap": ("==", 0, 0.05),
    "pillar_top_z": (">=", "pillar_min", 1e-6),
    "x_rack_engage_min": (">=", 8, 1e-6),
    "y_rack_engage_min": (">=", 8, 1e-6),
    "clamp_lip_t": ("<=", 1.5, 1e-6),
    "clamp_bottom_above_plug": (">=", 12.5, 1e-6),
    "plug_insert_err": ("==", 0, 1e-6),
    "flex_xz_stop": ("==", 1.5, 1e-6),
    "flex_beam_clear": (">", 1.5, 1e-6),
    # final-review fix pass
    "x_adj_engage": (">=", 0, 1e-6),
    "x_adj_hole": (">=", 0, 1e-6),
    "z_adj_engage": (">=", 0, 1e-6),
    "z_adj_hole": (">=", 0, 1e-6),
    "z_lock_pocket_w": (">=", 5.7, 1e-6),
    "holder_overhang": ("<=", 5, 1e-6),
    "m4_stage_bolt_protrude": ("<=", 0, 1e-6),
    "clamp_preload": (">=", 0.3, 1e-6),
    "clamp_lip_overlap": (">=", 0.4, 1e-6),
    "lip_hold_y": (">=", 1.5, 1e-6),
    "clamp_x_play": ("<=", 0.15, 1e-6),
    "horn_screw_land": ("<=", 3, 1e-6),
    "brace_slit_depth_margin": (">=", 0, 1e-6),
    "bracket_screw_room": (">=", 0.5, 1e-6),
    "pillar_above_flex": (">=", 5, 1e-6),
    "dt_chamfer": (">=", 0.5, 1e-6),
    "xbase_tower_gap": (">=", 1, 1e-6),
    "xb_window_min": (">=", 15, 1e-6),
    "jig_strip_w": (">=", 3, 1e-6),
}

# name -> (op, value, message)  failing these prints WARN, not FAIL
WARNS = {
    "x_travel_120": (">=", "x_travel",
                     "a servo with only 120 deg rotation cannot reach both ports"
                     " (reduce port_spacing or use a 180 deg servo)"),
}

# geometric probes that must hit something (the two-sided half of a fit test)
MUST_BE_NONEMPTY = [
    "tests/probe_port_hole_up.scad",
    "tests/probe_port_hole_down.scad",
    "tests/probe_plug_seat_up.scad",
    "tests/probe_plug_seat_side.scad",
    "tests/probe_plug_seat_back.scad",
    "tests/probe_jig_tower_px.scad",
    "tests/probe_jig_tower_nx.scad",
    "tests/probe_jig_tower_py.scad",
    "tests/probe_jig_tower_ny.scad",
    "tests/probe_jig_xbase_px.scad",
    "tests/probe_jig_xbase_nx.scad",
    "tests/probe_jig_xbase_py.scad",
    "tests/probe_x_rack_on_bed.scad",
    "tests/probe_y_rack_on_bed.scad",
    "tests/probe_zs_arrow_up.scad",
    "tests/probe_xs_arrow_up.scad",
    "tests/probe_xs_col_support_n.scad",
    "tests/probe_xs_col_support_p.scad",
]

MUST_BE_EMPTY = [
    "tests/collide_stage.scad",
    "tests/collide_port_rear.scad",
    "tests/collide_tool_access.scad",
    "tests/collide_x_axis.scad",
    "tests/collide_y_axis.scad",
    "tests/collide_plug_inserted.scad",
    "tests/collide_plug_tool.scad",
    "tests/collide_full.scad",
    "tests/probe_port_hole.scad",
    "tests/probe_plug_seat.scad",
    "tests/probe_xbase_lightened.scad",
    "tests/collide_servo_holder.scad",
    "tests/collide_plug_cradle.scad",
    "tests/probe_pinion_print.scad",
    "tests/probe_pinion_center_thru.scad",
    "tests/probe_zs_arrow.scad",
    "tests/probe_xs_arrow.scad",
    "tests/collide_tower_jig.scad",
    "tests/check_stage_base_symmetric.scad",
]

ECHO_RE = re.compile(r'ECHO: "CHECK", "([^"]+)", (.+)$')
EMPTY_MARKERS = ("Current top level object is empty",
                 "No top level geometry to render",
                 "Current top level object is not a 3D object")


def render(rel):
    path = os.path.join(ROOT, rel)
    if not os.path.exists(path):
        return 1, f"missing file {rel}", ""
    fd, out = tempfile.mkstemp(suffix=".stl")
    os.close(fd)
    try:
        p = subprocess.run(["openscad", "-o", out, path],
                           capture_output=True, text=True, timeout=1800)
        stl = open(out).read() if os.path.exists(out) else ""
        return p.returncode, p.stderr, stl
    finally:
        if os.path.exists(out):
            os.remove(out)


def bbox(stl):
    lo = [1e9] * 3
    hi = [-1e9] * 3
    for m in re.finditer(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", stl):
        for i in range(3):
            v = float(m.group(i + 1))
            lo[i] = min(lo[i], v)
            hi[i] = max(hi[i], v)
    return [h - l for l, h in zip(lo, hi)]


def min_z(stl):
    return min(float(m.group(1)) for m in
               re.finditer(r"vertex\s+\S+\s+\S+\s+(\S+)", stl))


def volume(stl):
    """Absolute enclosed volume of an ASCII STL (mm^3)."""
    pts = [tuple(map(float, m.groups())) for m in
           re.finditer(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", stl)]
    v = 0.0
    for i in range(0, len(pts) - 2, 3):
        (ax, ay, az), (bx, by, bz), (cx, cy, cz) = pts[i:i + 3]
        v += (ax * (by * cz - bz * cy) - ay * (bx * cz - bz * cx)
              + az * (bx * cy - by * cx)) / 6.0
    return abs(v)


def compare(op, a, b, tol=1e-6):
    return {"==": abs(a - b) <= tol, "<=": a <= b + tol,
            ">=": a >= b - tol, "<": a < b, ">": a > b}[op]


def main():
    os.chdir(ROOT)
    fails = 0
    checks = {}
    jobs = [(f, b, False) for f, b in TARGETS] + \
           [(f, False, True) for f in MUST_BE_EMPTY] + \
           [(f, False, "nonempty") for f in MUST_BE_NONEMPTY]
    with ThreadPoolExecutor(max_workers=os.cpu_count() or 4) as ex:
        results = list(ex.map(lambda j: (j, render(j[0])), jobs))

    for (f, bed, want_empty), (rc, err, stl) in results:
        for line in err.splitlines():
            m = ECHO_RE.search(line)
            if m:
                try:
                    checks[m.group(1)] = float(m.group(2))
                except ValueError:
                    checks[m.group(1)] = m.group(2)
        if want_empty == "nonempty":
            hard = any(k in err for k in ("ERROR", "missing file", "Can't open",
                                          "unknown module", "unknown variable",
                                          "unknown function"))
            vol = volume(stl) if stl else 0.0
            ok = vol >= 0.01 and not hard
            print(f"{'PASS' if ok else 'FAIL'} hits {f}"
                  + ("" if ok else f"  (overlap {vol:.3f} mm^3 or error)\n" + err[-400:]))
            fails += not ok
            continue
        if want_empty:
            # face-to-face sliding contact renders as zero-volume sheets
            empty = any(k in err for k in EMPTY_MARKERS) or volume(stl) < 0.01
            hard = any(k in err for k in ("ERROR", "missing file", "Can't open",
                                          "unknown module", "unknown variable",
                                          "unknown function"))
            ok = empty and not hard
            print(f"{'PASS' if ok else 'FAIL'} empty {f}"
                  + ("" if ok else f"  (overlap {volume(stl):.3f} mm^3 or error)\n"
                     + err[-400:]))
            fails += not ok
            continue
        bad = [l for l in err.splitlines() if "WARNING" in l or "ERROR" in l]
        if not bed:
            bad = [l for l in bad if "2-manifold" not in l]
        msg = ""
        if rc != 0 or bad:
            msg = f"rc={rc} " + " | ".join(bad[:5] or err.splitlines()[-3:])
        elif bed:
            dims = bbox(stl)
            if not stl or max(dims) > BED:
                msg = f"bbox {[round(d, 1) for d in dims]} exceeds {BED}"
            elif f.startswith("parts/") and abs(min_z(stl)) > 0.01:
                msg = f"print orientation: lowest point at z={min_z(stl):.2f}, not on the bed"
        print(f"{'FAIL' if msg else 'PASS'} render {f}"
              + (f"  {msg}" if msg else ""))
        fails += bool(msg)

    for name, (op, val, tol) in EXPECT.items():
        target = checks.get(val) if isinstance(val, str) else val
        got = checks.get(name)
        if not isinstance(got, float) or not isinstance(target, float | int):
            print(f"FAIL check {name}: missing (got {got!r}, target {target!r})")
            fails += 1
            continue
        ok = compare(op, got, target, tol)
        print(f"{'PASS' if ok else 'FAIL'} check {name} = {got:g} {op} {target:g}")
        fails += not ok

    for name, (op, val, message) in WARNS.items():
        target = checks.get(val) if isinstance(val, str) else val
        got = checks.get(name)
        if isinstance(got, float) and isinstance(target, float | int) \
                and not compare(op, got, target):
            print(f"WARN {name} = {got:g}: {message}")

    print(f"\n{'ALL PASS' if not fails else f'{fails} FAILURE(S)'}")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
