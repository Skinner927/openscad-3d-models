// The inverted MG995 (including the triangle braces on its ears) must sit
// flush in its holder: no overlap between servo and holder.
include <../lib.scad>
intersection() { mg995_model(); mg995_holder(); }
