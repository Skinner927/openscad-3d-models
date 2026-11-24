#!/usr/bin/env python3
"""Render assembly_labeled.png: the assembly view with every part named.

Each part is tagged in the .scad sources with show("<name>"). For each
name the assembly is rendered alone (-D '$only="<name>"') with the same
camera as the full view. Pixels where the solo render matches the full
render are where that part is actually visible, so arrows only ever point
at a visible face. Each arrow lands on the most solid visible spot.

    usage: python3 -I annotate_assembly.py [out.png]     (from anywhere)
Needs: openscad, Pillow, numpy.
"""
import os
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

import numpy as np
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
CAMERA = "550,-240,400,0,-60,25"  # same view as assembly.png
SIZE = 1200
MARGIN = 330  # label column width, each side

# (show() tag, label). Printed parts use their stl/ file name.
PARTS = [
    ("stage_base", "stage_base"),
    ("stage_x_slider", "stage_x_slider"),
    ("stage_z_slider", "stage_z_slider"),
    ("stage_z_cap", "stage_z_cap"),
    ("port_bracket", "port_bracket"),
    ("x_base", "x_base"),
    ("x_carriage", "x_carriage"),
    ("y_carriage", "y_carriage"),
    ("pinion", "pinion"),
    ("servo_holder", "servo_holder"),
    ("plug_flexure", "plug_flexure"),
    ("plug_clamp_cap", "plug_clamp_cap"),
    ("plug_flex_stop", "plug_flex_stop"),
]
HARDWARE = [
    ("servo", "MG995 servo"),
    ("bulkhead", "magnetic bulkhead port"),
    ("usb_plug", "magnetic USB plug"),
]


def render(out, only=None):
    cmd = ["openscad", "-o", out, os.path.join(HERE, "assembly.scad"),
           f"--camera={CAMERA}", f"--imgsize={SIZE},{SIZE}", "-D", "show_plywood=false"]
    if only:
        cmd += ["-D", f'$only="{only}"']
    r = subprocess.run(cmd, capture_output=True, text=True)
    bad = [l for l in r.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
    if r.returncode or bad:
        raise RuntimeError(f"openscad {only or 'full'}: {(bad or [r.stderr[-300:]])[0]}")
    return np.asarray(Image.open(out).convert("RGB")).astype(int)


def anchor(full, solo):
    """Deepest point of the part's visible area, or None if hidden."""
    bg = solo[0, 0]
    mask = (np.abs(solo - bg).sum(2) > 0) & (np.abs(solo - full).max(2) <= 6)
    if mask.sum() < 30:
        return None
    last = mask
    while mask.any():  # erode until nothing is left: `last` is the core
        last = mask
        m = mask.copy()
        m[1:] &= mask[:-1]; m[:-1] &= mask[1:]
        m[:, 1:] &= mask[:, :-1]; m[:, :-1] &= mask[:, 1:]
        m[0] = m[-1] = False; m[:, 0] = m[:, -1] = False
        mask = m
    ys, xs = np.nonzero(last)
    i = np.argmin((ys - ys.mean()) ** 2 + (xs - xs.mean()) ** 2)
    return int(xs[i]), int(ys[i])


def spread(ys, gap, lo, hi):
    """Label y positions near the wanted ones, at least `gap` apart."""
    out = list(ys)
    for i in range(1, len(out)):
        out[i] = max(out[i], out[i - 1] + gap)
    if out and out[-1] > hi:
        out[-1] = hi
        for i in range(len(out) - 2, -1, -1):
            out[i] = min(out[i], out[i + 1] - gap)
    return [max(lo, y) for y in out]


def crosses(p1, p2, q1, q2):
    def side(a, b, c):
        return np.sign((b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0]))
    return side(p1, p2, q1) * side(p1, p2, q2) < 0 and side(q1, q2, p1) * side(q1, q2, p2) < 0


def uncross(slots, items, start):
    """Swap which item sits in which label slot until no leader lines
    cross. Each swap shortens the total line length, so it ends."""
    items = list(items)
    for _ in range(len(items) ** 3):
        hit = next(((i, j) for i in range(len(items)) for j in range(i + 1, len(items))
                    if crosses(start(slots[i], items[i]), items[i][1],
                               start(slots[j], items[j]), items[j][1])), None)
        if not hit:
            break
        i, j = hit
        items[i], items[j] = items[j], items[i]
    return items


def font(size):
    for f in ("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"):
        if os.path.exists(f):
            return ImageFont.truetype(f, size)
    return ImageFont.load_default(size)


def arrow(d, a, b, colour):
    d.line([a, b], fill="white", width=6)
    d.line([a, b], fill=colour, width=2)
    v = np.subtract(b, a, dtype=float)
    v /= max(np.hypot(*v), 1e-9)
    n = np.array([-v[1], v[0]])
    tip = np.array(b, float)
    head = [tuple(tip), tuple(tip - 16 * v + 6 * n), tuple(tip - 16 * v - 6 * n)]
    d.polygon(head, fill=colour, outline="white")
    d.ellipse([b[0] - 5, b[1] - 5, b[0] + 5, b[1] + 5], fill=colour, outline="white", width=2)


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "assembly_labeled.png")
    labels = PARTS + HARDWARE
    missing = [t for t, _ in PARTS if not os.path.exists(os.path.join(HERE, "parts", t + ".scad"))]
    if missing:
        sys.exit(f"no parts/<name>.scad for: {', '.join(missing)}")
    with tempfile.TemporaryDirectory() as tmp, ThreadPoolExecutor(os.cpu_count()) as pool:
        full_f = pool.submit(render, os.path.join(tmp, "full.png"))
        solos = {t: pool.submit(render, os.path.join(tmp, t + ".png"), t) for t, _ in labels}
        full = full_f.result()
        pts = {t: anchor(full, f.result()) for t, f in solos.items()}
        base = Image.open(os.path.join(tmp, "full.png")).convert("RGB")
    hidden = [t for t, p in pts.items() if p is None]
    if hidden:
        sys.exit(f"not visible in the view: {', '.join(hidden)}")

    bg = tuple(int(c) for c in full[0, 0])
    img = Image.new("RGB", (SIZE + 2 * MARGIN, SIZE), bg)
    img.paste(base, (MARGIN, 0))
    d = ImageDraw.Draw(img)
    f = font(26)
    hw = {t for t, _ in HARDWARE}
    for side in ("left", "right"):
        # item: (text, anchor point, tag), sorted top to bottom
        group = sorted(((txt, (pts[t][0] + MARGIN, pts[t][1]), t) for t, txt in labels
                        if (pts[t][0] < SIZE / 2) == (side == "left")), key=lambda g: g[1][1])
        ys = spread([g[1][1] for g in group], 46, 30, SIZE - 30)

        def text_x(item):
            w = d.textlength(item[0], font=f)
            return 16 if side == "left" else SIZE + 2 * MARGIN - 16 - w

        def start(ly, item):
            w = d.textlength(item[0], font=f)
            return (text_x(item) + w + 8, ly) if side == "left" else (text_x(item) - 8, ly)

        for ly, item in zip(ys, uncross(ys, group, start)):
            txt, a, t = item
            colour = (90, 90, 90) if t in hw else (20, 20, 20)
            d.text((text_x(item), ly), txt, font=f, fill=colour, anchor="lm")
            arrow(d, start(ly, item), a, colour)
    img.save(out)
    print(f"ok   {os.path.relpath(out)}")


if __name__ == "__main__":
    main()
