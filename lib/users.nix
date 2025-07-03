{lib}: {
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
    openssh =
      lib.mkIf (github_keys_url && sha256)
      lib.strings.splitString
      "\n"
      (
        builtins.readFile (
          builtins.fetchurl {
            url = "${github_keys_url}";
            sha256 = "${sha256}";
          }
        )
      );
  in {
    users.users = lib.mkIf (description && username) {
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

        openssh.authorizedKeys.keys = openssh;
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
  };
}
