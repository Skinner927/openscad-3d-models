
s = 38;

linear_extrude(height = s)
polygon([
  [0, 0], [0, s],
  [s, 0]
]);
