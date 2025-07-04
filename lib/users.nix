{lib}: let
  mkUsers = users: upstream: let
    inputs = upstream.inputs;
    outputs = upstream.outputs;
  in {
    # mapped users
    users.users = builtins.listToAttrs (builtins.map (i: {
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

          openssh.authorizedKeys.keys =
            lib.optionals # function
            ((i.githubKeysUrl != "") && (i.sha256 != "")) # arg1
            (lib.strings.splitString 
            "\n" (builtins.readFile (builtins.fetchurl {url = "${i.githubKeysUrl}"; sha256 = "${i.sha256}";}))) # arg2
          ;
        };
      })
      users);

    home-manager = {
      backupFileExtension = "hbak";

      extraSpecialArgs = {
        inherit inputs outputs;
      };
      # mapped home-manager
      users = builtins.listToAttrs (builtins.map (i: {
          # Import your home-manager configuration
          name = "${i.username}";
          value = import ./home.nix upstream i.homeModules i.username;
        })
        users);
    };
  };
in {inherit mkUsers;}
