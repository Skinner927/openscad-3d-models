// Plug flexure + clamp cradle. Qty 1.
// Print flat on its back face (cradle up). PLA/PETG with flex_beam_w=1.2,
// or TPU (95A) with flex_beam_w around 2 for a softer float.
include <../plug_mount.scad>
rotate([90, 0, 0]) plug_flexure();
