# This one brings our custom packages from the 'pkgs' directory
{inputs, ...}: final: _prev:
# Stored scripts
(
  (import ../packages {
    inherit inputs;
    pkgs = final;
  })
  // {
    # Uzinfocom Scope
    uzinfocom = {
      gate = inputs.gate.packages.${final.system}.default;
    };
  }
)
