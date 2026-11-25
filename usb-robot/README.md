# USB Switcher Robot

A tabletop machine that moves one magnetic USB plug between two
magnetic bulkhead ports, which switches a USB device between two
computers. Two MG995 servos drive it through printed racks and pinions.
Fine screw-adjust stages handle alignment, and a printed flexure lets the
magnets pull the plug the last millimetre or so.

![](assembly.png)

The same view with every part named (`assembly_labeled.png`):

![](assembly_labeled.png)

Open `assembly.scad` to see the whole machine. Use the Customizer to
switch between `show_port` 0 and 1, and slide `y_pos` (0 = retracted,
20 = plugged in).

Design notes:
- `docs/superpowers/specs/2026-11-03-usb-robot-design.md`
- `docs/superpowers/plans/2026-11-03-usb-robot.md`

## Layout (plywood top = Z 0)

```
          port A          port B         <- bulkhead bodies go back (+Y)
        [tower A]  60mm  [tower B]       <- plates face -Y, port centre Z 80
   - - - - - - - - - - - - - - - - - -
        [ male stage + flexure + plug ]  <- Y carriage (in/out 20 mm)
        [ X carriage  + Y servo       ]  <- slides 70 mm along X
        [ X base + X servo (rear)     ]
```

Everything stands on one printed base, `x_base`: the X axis at the front
and both towers' rails and adjust tabs at the back, already in their exact
positions. Screw it to the plywood with 7 wood screws. No placement jig is
needed.

## Print list

RUn `./export_stls.sh` to generate the STLs to print in `stl/`.

Use PLA or PETG with 3–4 walls and 30% infill unless noted.
Use `Inner/Outer/Inner` for "Walls printing order" if your slicer has the
setting.

| File (`stl/`)                 | Qty | Orientation / notes                                                   |
| ----------------------------- | --- | --------------------------------------------------------------------- |
| `nut_spanner.stl`             | 1   | flat. Optional tool: holds the adjust-screw nylocks (5.4mm nuts)      |
| `pinion.stl`                  | 2   | horn recess up as exported, no supports                               |
| `plug_clamp_cap.stl`          | 1   | flat                                                                  |
| `plug_flex_stop.stl`          | 2   | pin up                                                                |
| `plug_flexure.stl`            | 1   | back face down. PLA/PETG `flex_beam_w=1.2`, or TPU (untested) with ~2 |
| `port_bracket.stl`            | 2   | flat back face down, ribs up                                          |
| `servo_holder.stl`            | 2   | ear plate on the bed, walls up (X servo + Y servo)                    |
| `stage_x_slider.stl`          | 3   | upright, slot down (bridges). Same part for every stage               |
| `stage_z_cap.stl`             | 3   | flat. Same part for every stage (flip it for tower B)                 |
| `stage_z_slider.stl`          | 2   | lying on payload face.                                                |
| `stage_z_slider_mirrored.stl` | 1   | lying on payload face. For tower B.                                   |
| `x_base.stl`                  | 1   | flat, about 201 × 209mm. Tower bases (rails + tabs) built in          |
| `x_carriage.stl`              | 1   | slots down                                                            |
| `y_carriage.stl`              | 1   | slot down, pillar up. Male stage base/rail built in                   |

## Hardware

| Item                                        | Qty | Where                                                             |
| ------------------------------------------- | --- | ----------------------------------------------------------------- |
| MG995 servo (+ round horn and its screws)   | 2   | X and Y axes                                                      |
| M2x6 self-tapping                           | 8   | Servo horn (spline mount) to pinion gear (YMMV, vendor dependent) |
| M3×30 + M3 nylock + M3 nut \*               | 3   | X adjust screw, per stage                                         |
| M3×30 + M3 nylock + M3 nut \*               | 3   | Z adjust screw, per stage                                         |
| M3×12 + M3 nut (≤ 4mm thick, nylock OK)     | 3   | X lock screw, per stage (towers: back face; male stage: front)    |
| M3×12 + M3 nut (≤ 4mm thick, nylock OK)     | 3   | Z lock screw, per stage (outward side, head in a counterbore)     |
| M3×12 (self-tapping into the column)        | 6   | Cap to column, 2 per stage                                        |
| M3×12 + M3 nut                              | 4   | Port bracket to stage                                             |
| M3×12 + M3 nut                              | 2   | Flexure to male stage                                             |
| M3×12 self-tapping                          | 8   | Servo ears to holders                                             |
| M3×12 self-tapping                          | 6   | Holders to X base / X carriage, from underneath                   |
| M3×12 (self-tapping)                        | 2   | Clamp cap to cradle                                               |
| M3×16 + M3 nut \*\*                         | 2   | Stop straps, through the flexure top bar (`plug_flex_stop.stl`)   |
| #8 / M4 wood screw, ~20mm                   | 7   | X base: 5 around the X axis + 2 at the towers' back corners       |
| Zip tie, ≤ 3mm wide × ≤ 2.5mm thick, ~150mm | 7   | Cable pillar (2), X servo lead (1), Y servo lead (2), spares (2)  |


**\* The M3×30 adjust screws are optional.** They give fine, screw-driven
adjustment (0.5mm per turn). Without them, loosen the lock screws, slide
each stage into place with your fingers, and tighten the lock screws
again. Skipping them also skips their nylocks and nuts: 6 fewer of each.

**\*\* The M3×16 for the stop straps are optional.** If you do not have
M3×16 bolts, longer or similar sized bolts can be used instead. There are no
sized nut holes to worry about. The stop straps are only there to prevent the
flexure from over extending and breaking in extreme cases. You may choose to
omit it entirely.

The nuts sit in printed nut traps. Push each nut in before inserting its
screw.

### Order totals

| Item                                        | Required | With optional parts (\*, \*\*) |
| ------------------------------------------- | -------- | ------------------------------ |
| MG995 servo (+ round horn and its screws)   | 2        | 2                              |
| M2×6 self-tapping                           | 8        | 8                              |
| M3×12                                       | 34       | 34                             |
| M3×16                                       | 0        | 2                              |
| M3×30                                       | 0        | 6                              |
| M3 nut                                      | 12       | 20                             |
| M3 nylock                                   | 0        | 6                              |
| #8 / M4 wood screw, ~20mm                   | 7        | 7                              |
| Zip tie, ≤ 3mm wide × ≤ 2.5mm thick, ~150mm | 7        | 7                              |

All 34 M3×12 can be ordinary machine screws: 12 take a nut, and the 22
marked self-tapping cut their own thread in 2.9mm printed holes. The 6
lock nuts may be nylocks if you have them.

## Assembly notes

1. **Port towers:**
   1. Push an M3 nut, corner down, up into the pocket in the x-slider's
      underside behind the hole in the middle of the back face. Hold it
      there, lower the x-slider straight down into the gap between the
      two towers' rail ends (column toward the back), and slide it outward onto
      its rail; the nut then rides on the base. The X lock screw goes into
      that back hole; the two holes on the front face (toward the X
      axis, 8mm either side of centre) are for the male stage, which
      uses one of them instead because its back faces the cable pillar.
      Its nut drops into the slot above that hole, corner down.
   2. Drop an M3 nut into the X adjust slot at the end that faces the
      base's screw tab (the slot at the other end stays empty). Fit the X
      adjust screw: it goes through the tab, then the nylock goes on
      inside the tab. Snug the nylock so the screw turns freely
      without end play, then thread the screw into the slider's captive
      nut. To snug it, hold the nylock with the spanner's 15° end from
      above (stage near mid travel) and turn the screw head.
   3. Slide the z-slider onto the column. Bolt the cap on (upside down
      on tower B, so its Z adjust hole lines up) and fit the Z adjust
      screw the same way, **before the port bracket goes on**: the bracket
      blocks the nylock under the cap. Reach it with the spanner's 15° end
      from the front, or its 90° end from the side.
   4. Push the bulkhead through the bracket's D-hole **from the back**, so
      the flange sits behind the plate. The flat on the thread goes up.
      Fit the nut on the front.
2. **Pinions:** screw each pinion onto a round horn with the horn's small
   screws. Centre the servo (send a 1500µs pulse) before pressing the horn
   on, so the servo's travel is centred on the rack. The servo's centre
   screw goes through the pinion's 7mm centre hole and seats on the horn
   hub, so the stock screw is long enough.
3. **Servos:** both mount **upside down** (shaft pointing down) in the
   two identical printed holders. The ears rest on the holder plate and
   take M3 self-tappers.
   - Each holder screws to the X base or X carriage with 3× M3×12
     self-tappers driven up from underneath (counterbored so the same
     length fits both).
   - The holder's long side wall goes on the side away from the rack.
   - The horn screws pass through counterbores in the pinion, leaving
     2.5mm of material to clamp.
   - If the pinion doesn't line up in height with the rack, adjust
     `servo_ear_to_pinion` in `common.scad` (default 14mm, from the ears'
     shaft-side face to the pinion's horn face) and reprint the holder
     part.
4. **Plug:**
   1. Push the plug up into the cradle from below, cable first, so the
      strain relief comes up through the hole in the top lips. Seat the
      block against the lips (that sets its height), then screw the clamp
      cap on. The cradle is built for a plug whose bend turns
      toward the 11mm side (`plug_rot = 90`). For one that turns toward
      the 6mm side, set `plug_rot = 0` in `common.scad` and reprint.
   2. Fit the two stop straps, one in front of the flexure top bar and one
      behind it, with their pins in the island's hole. Bolt them through
      the bar.
   3. Run the cable up the pillar and zip-tie it through the two slots.
      Leave a slack loop between the pillar and the clamp.

## Alignment procedure

1. With the plug retracted, drive X to port A.
2. Loosen the lock screws on the male stage. The Z adjust screw sits on
   the column cap, off to one side of the bulkhead body. Turn its X and Z screws
   (0.5mm per turn) until the plug face is centred on port A, then lock
   it.
3. Drive X to port B. Centre **tower B's** stage on the plug instead of
   moving the male stage again, then lock it. Tower A's stage is your
   spare trim.
4. Plug in slowly (raise Y) and check that the magnets snap together and
   the flexure ends up near the middle of its float. Set the servo end
   points in software, about 1mm past contact.

## Servo travel

- **X:** 70.7mm over 180° (45mm pitch-diameter pinion), which is 0.39mm
  per degree. Moving between ports (60mm) takes about **153°**.
  - If your MG995 only turns about 120° (47mm), it can't reach both
    ports. Use a 180° servo, or reduce `port_spacing`. The towers need at
    least 56mm between ports.
- **Y:** a 20mm stroke takes about **51°**.

## Servo wire routing

Both servos hang upside down, so each lead leaves the top of the case
at the front (+Y, shaft) end, toward the racks. Tie it back:

1. Bend the lead back over the top of the servo and down its rear end.
2. Lay it on the tab at the rear of the holder's ear plate, between the
   two slots.
3. Run one zip tie down one slot, up the other and around the lead.

- **X servo:** it doesn't move. Use the tab at the rear of its holder,
  then run the lead on to the controller.
- **Y servo:** it rides on the X carriage, so its lead goes off the −X
  end instead, away from both pinions:
  1. Run the lead down the servo's −X side and tie it to the tab on the
     holder's side wall (same two-slot tie as above).
  2. Tie it again to the post at the X base's −X end: one zip tie
     through the tunnel under the post top, over the lead.
  3. Leave about 90mm of lead between the two ties. At the −X end of
     travel the slack hangs off the end of the base; at the +X end it
     pulls straight.

## Tests

```
python3 -I usb-robot/tests/run_tests.py
```

The test script renders every part with the OpenSCAD CLI and checks five
things:
- There are no warnings, and each part fits the bed.
- Gear mesh, travel, and heights are correct.
- Collisions: the stage at its travel limits, the bulkhead's rear space,
  screwdriver reach, the X and Y axes, the plug at each port, and the
  whole machine across its full travel.
- The plug height matches the port height.
- A warning line appears when 120° of servo rotation isn't enough to
  reach both ports.
