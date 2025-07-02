{lib}: let
  mkUsers = {
    inputs,
    outputs,
    config,
    pkgs,
    # user properties
    username,
    hashedPassword,
    description,
    github_keys_url ? "",
    sha256 ? "",
    home_nix_path,
  }: let
    users.users = {
    "${username}" = {
      inherit hashedPassword;
      isNormalUser = true;
      description = "${description}";

      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "admins"
      ];

      openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
        builtins.readFile (
          builtins.fetchurl {
            url = "${github_keys_url}";
            sha256 = "${sha256}";
          }
        )
      );
    };
  };

  home-manager = {
    backupFileExtension = "hbak";

    extraSpecialArgs = {
      inherit inputs outputs;
    };

    users = {
      # Import your home-manager configuration
      "${username}" = import home_nix_path {
        inherit pkgs inputs config;
      };
    };
  };

  map = lib.map username hashedPassword description github_keys_url sha256 home_nix_path;
in
  lib.listToAttrs map;
in {
  inherit mkUsers;
}
