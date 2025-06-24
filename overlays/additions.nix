# This one brings our custom packages from the 'pkgs' directory
{inputs, ...}: final: _prev:
# Stored scripts
(
  # Scripts derived from this flake
  (import ../packages {
    pkgs = final;
  })
  // # and
  
  # Third Party packages
  {
    # Uzinfocom Scope
    uzinfocom = {
      gate = inputs.gate.packages.${final.system}.default;
    };
  }
)
