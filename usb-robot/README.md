# USB Switcher Robot

A tabletop machine that moves one magnetic USB plug between two
magnetic bulkhead ports, which switches a USB device between two
computers. Two MG995 servos drive it through printed racks and pinions.
Fine screw-adjust stages handle alignment, and a printed flexure lets the
magnets pull the plug the last millimetre or so.

![](assembly.png)

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

Screw everything to the plywood in this arrangement:
- **Port towers:** tower A's plate front face is at world y = 0, and
  tower B sits 60mm to its right (+X).
- **X base:** put it in front of the towers (−Y), leaving a 6mm gap
  between its back edge and the front edge of the tower bases.

**Placement jig (`tower_jig.scad`):** a flat 3mm frame that sets both
tower bases exactly.
1. Screw the X base down.
2. Lay the jig on the plywood with its straight front strip against the
   X base's back edge and its two arms around the X base's back corners.
3. Drop the two **bare** stage bases into the pockets with their
   adjust-screw tabs facing outward (left on tower A, right on tower B).
   It's the same part both times, just turned around.
4. Screw both bases down, lift the jig straight off, then build the
   stages on the bases.

`assembly.scad` shows the exact relative positions. Exact placement isn't
critical: the stages and the servo end points take up the error.

## Print list

Ready-made STLs are in `stl/`, with `*_mirrored.stl` for tower B (stage base excepted: one part serves both sides). Re-export them after changing any parameter in `common.scad` by running `./export_stls.sh` (about 30 seconds).

Use PLA or PETG with 3–4 walls and 30% infill unless noted. Every part
fits a 250mm bed.

| File (`parts/`)       | Qty | Orientation / notes                                        |
| --------------------- | --- | ---------------------------------------------------------- |
| `stage_base.scad`     | 3   | as modelled. Same part for every stage (turn it around)    |
| `stage_x_slider.scad` | 3   | upright, slot down (bridges). 1 mirrored                   |
| `stage_z_slider.scad` | 3   | lying on payload face. 1 mirrored                          |
| `stage_z_cap.scad`    | 3   | flat. 1 mirrored                                           |
| `port_bracket.scad`   | 2   | flat back face down, ribs up                               |
| `x_base.scad`         | 1   | flat, about 190 × 155mm                                    |
| `x_carriage.scad`     | 1   | slots down                                                 |
| `y_carriage.scad`     | 1   | slot down, pillar up                                       |
| `pinion.scad`         | 2   | horn recess up as exported, no supports                    |
| `servo_holder.scad`   | 2   | ear plate on the bed, walls up (X servo + Y servo)         |
| `plug_flexure.scad`   | 1   | back face down. PLA/PETG `flex_beam_w=1.2`, or TPU with ~2 |
| `plug_clamp_cap.scad` | 1   | flat                                                       |
| `plug_flex_stop.scad` | 2   | pin up                                                     |
| `tower_jig.scad`      | 1   | flat as exported. Tower-base placement jig (see Layout)    |

The mirrored x-slider, z-slider and cap go on **port tower B**, so both
towers' X adjust screws face outward. The stage base needs no mirrored
version: turned 180° it is its own mirror image. The male stage can be either hand.

## Hardware

| Item                                        | Qty | Where                                                              |
| ------------------------------------------- | --- | ------------------------------------------------------------------ |
| MG995 servo (+ round horn and its screws)   | 2   | X and Y axes                                                       |
| M3×30 + M3 nylock + M3 nut                  | 3   | X adjust screw, per stage                                          |
| M3×30 + M3 nylock + M3 nut                  | 3   | Z adjust screw, per stage                                          |
| M3×12 + M3 nut                              | 3   | X lock screw, per stage                                            |
| M3×16 + M3 nut                              | 3   | Z lock screw, per stage (enters from the outward side)             |
| M3×12 (self-tapping into the column)        | 6   | Cap to column, 2 per stage                                         |
| M3×12 + M3 nut                              | 4   | Port bracket to stage                                              |
| M3×12 + M3 nut                              | 2   | Flexure to male stage                                              |
| M3×12 self-tapping                          | 8   | Servo ears to holders                                              |
| M3×12 self-tapping                          | 6   | Holders to X base / X carriage, from underneath                    |
| M3×12 (self-tapping)                        | 2   | Clamp cap to cradle                                                |
| M3×16 + M3 nut                              | 2   | Stop straps, through the flexure top bar                           |
| M4×12 + M4 nut                              | 4   | Male stage base to Y carriage (longer bolts scrape the X carriage) |
| #8 / M4 wood screw, ~20mm                   | 13  | 2 tower bases (4 each) + X base (5)                                |
| Zip tie, ≤ 3mm wide × ≤ 2.5mm thick, ~150mm | 6   | Cable pillar (2), servo leads (2), spares (2)                      |

The nuts sit in printed nut traps. Push each nut in before inserting its
screw.

## Assembly notes

1. **Port towers:**
   1. Slide the x-slider onto the base rail.
   2. Fit the X adjust screw: it goes through the tab, then the nylock
      goes on inside the tab. Snug the nylock so the screw turns freely
      without end play, then thread the screw into the slider's captive
      nut.
   3. Slide the z-slider onto the column. Bolt the cap on and fit the Z
      adjust screw the same way.
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

- **X servo:** it doesn't move. Run the lead on to the controller.
- **Y servo:** it rides on the X carriage. Leave a 100mm service loop
  after the tab so the lead can follow the 70mm X stroke.

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
