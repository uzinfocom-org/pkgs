# This one contains whatever you want to overlay
# You can change versions, add patches, set compilation flags, anything really.
# https://wiki.nixos.org/wiki/Overlays
{...}: _final: _prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
}
