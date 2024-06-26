// Designed to be run by render.ps1
model = "not defined";
echo(model=model);

use <variables.scad>
use <gears.scad>

if ("gear_usb" == model) {
  gear_usb();
}
