{
  #    __  __      _       ____
  #   / / / /___  (_)___  / __/___  _________  ____ ___
  #  / / / /_  / / / __ \/ /_/ __ \/ ___/ __ \/ __ `__ \
  # / /_/ / / /_/ / / / / __/ /_/ / /__/ /_/ / / / / / /
  # \____/ /___/_/_/ /_/_/  \____/\___/\____/_/ /_/ /_/
  description = "Collection of packages and functions by Uzinfocom";

  # inputs are other flakes you use within your own flake, dependencies
  # for your flake, etc.
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Unstable Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/unstable.nix'.
    # Don't forget to align unstable repo with user's flake inputs!

    # Flake utils for eachSystem
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
  # Attributes for each system
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        # Nixpkgs packages for the current system
        {
          # Your custom packages
          # Acessible through 'nix build', 'nix shell', etc
          packages = import ./packages {inherit pkgs;};

          # Formatter for your nix files, available through 'nix fmt'
          # Other options beside 'alejandra' include 'nixpkgs-fmt'
          formatter = pkgs.alejandra;

          # Development shells
          devShells.default = import ./shell.nix {inherit pkgs;};
        }
    )
    # and ...
    //
    # Attribute from static evaluation
    {
      # Personal functions and extensions
      lib = import ./lib {inherit (nixpkgs) lib;};

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays {inherit inputs;};
    };

}
