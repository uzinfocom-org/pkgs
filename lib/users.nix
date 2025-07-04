{lib}: let
  mkUsers = {
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    # home-manager users data
    users,
  }: let
    nixosUsers = builtins.listToAttrs (builtins.map (i: {
        name = i.username;
        value = {
          hashedPassword = "${i.hashedPassword}";
          isNormalUser = true;
          description = "${i.description}";

          extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
            "admins"
          ];

          openssh.authorizedKeys.keys = lib.mkIf ((i.githubKeysUrl != "") && (i.sha256 != "")) (
            lib.strings.splitString
            "\n"
            (
              builtins.readFile (
                builtins.fetchurl {
                  url = "${i.githubKeysUrl}";
                  sha256 = "${i.sha256}";
                }
              )
            )
          );
        };
      })
      users);

    homeUsers = builtins.listToAttrs (builtins.map (i: {
        # Import your home-manager configuration
        name = "${i.username}";
        value = import i.homePath {
          inherit pkgs inputs config lib;
        };
      })
      users);
  in {
    # mapped users
    users.users = nixosUsers;

    home-manager = {
      backupFileExtension = "hbak";

      extraSpecialArgs = {
        inherit inputs outputs;
      };
      # mapped home-manager
      users = homeUsers;
    };
  };
in {inherit mkUsers;}
