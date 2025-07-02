{lib}: {
  config = import ./config.nix {inherit lib;};
  condition = import ./condition.nix {inherit lib;};
  users = import ./users.nix {inherit lib;};
}
