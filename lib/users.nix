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
    githubKeysUrl ? "",
    sha256 ? "",
    homePath,
  }: let
    openssh =
      lib.mkIf (githubKeysUrl && sha256)
      lib.strings.splitString
      "\n"
      (
        builtins.readFile (
          builtins.fetchurl {
            url = "${githubKeysUrl}";
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
        "${username}" = import homePath {
          inherit pkgs inputs config;
        };
      };
    };
  };
}
