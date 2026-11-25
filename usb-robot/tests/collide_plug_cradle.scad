// The plug must fit the flexure's cradle: pushed up into it from below
// (block and bent body swept 20 mm up), and at rest including the cable
// strain relief, which sits in the hole through the top lips. The relief
// is not swept: it is squeezed past the cradle walls by hand. The clamp
// cap is excluded (it squeezes by design).
include <../plug_mount.scad>
intersection() {
    plug_flexure();
    union() {
        plug_body_pieces(sweep = [0, 0, -20], relief = false);
        plug_body_pieces();
    }
}
