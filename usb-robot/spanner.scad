// ============================================================
//  Nut spanner: flat, double-ended open spanner for the M3 nylocks on
//  the adjust screws (hold the nylock, turn the screw head).
//  End 0: mouth 15 deg off the handle (X nylock, from above).
//  End 1: mouth 90 deg to the handle (Z nylock, from the side).
//  Lies flat on z = 0..spanner_t, end 0's nut centre at the origin,
//  handle along +X.
// ============================================================
include <lib.scad>

spanner_af = lock_nut_af + 0.2; // same tight fit as the nut pockets
spanner_t = 3; // fits the 4 mm nylock with room to spare
spanner_jaw = 3; // jaw wall
spanner_tip = 2.4; // jaw tips past the nut centre
spanner_len = 75; // end centre to end centre
spanner_w = 8; // handle width
spanner_mouth = [165, 90]; // mouth direction per end, from the handle (+X)
spanner_label = "5.5mm"; // nominal spanner size (M3 nut)
spanner_label_depth = 0.6; // recessed into the top face

_sp_corner = spanner_af / cos(30) / 2; // hex throat: flats on the jaw faces
_sp_back = _sp_corner + spanner_jaw; // nut centre to the back of the head

function spanner_centre(e) = e == 0 ? [0, 0] : [spanner_len, 0];
// end 1's mouth points -Y, so its handle runs away toward -X when posed
function spanner_dir(e) = e == 0 ? spanner_mouth[0] : 360 - spanner_mouth[1];

// head outline / slot, mouth along +Y, nut centre at the origin
module spanner_head_2d() {
    hw = spanner_af / 2 + spanner_jaw;
    offset(r = 1.5) offset(delta = -1.5)
        translate([-hw, -_sp_back]) square([2 * hw, _sp_back + spanner_tip]);
}
module spanner_slot_2d() {
    translate([-spanner_af / 2, 0]) square([spanner_af, spanner_tip + 1]);
    rotate(90) circle(r = _sp_corner, $fn = 6); // flats on the jaws
}

// handle ends sit behind each head so they never reach past the jaw tips
_sp_handle = [[6, 0], [spanner_len - 6, 2]];

// size label along the handle's centre line
module spanner_label_2d() {
    a = _sp_handle[0]; b = _sp_handle[1];
    translate((a + b) / 2) rotate(atan2(b[1] - a[1], b[0] - a[0]))
        text(spanner_label, size = 4.5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
}

module nut_spanner() {
    difference() {
        spanner_body();
        translate([0, 0, spanner_t - spanner_label_depth]) linear_extrude(spanner_label_depth + 1) spanner_label_2d();
    }
}

module spanner_body() {
    linear_extrude(spanner_t) difference() {
        union() {
            for (e = [0, 1]) translate(spanner_centre(e)) rotate(spanner_dir(e) - 90) spanner_head_2d();
            hull() for (p = _sp_handle) translate(p) circle(d = spanner_w, $fn = 32);
        }
        for (e = [0, 1]) translate(spanner_centre(e)) rotate(spanner_dir(e) - 90) spanner_slot_2d();
    }
}

// Spanner placed with end e's nut centre at the origin, its mouth along
// +Y and its thickness centred on z = 0 (for fit and reach checks).
module spanner_at(e) {
    rotate(90 - spanner_dir(e)) translate([-spanner_centre(e)[0], -spanner_centre(e)[1], -spanner_t / 2])
        nut_spanner();
}
