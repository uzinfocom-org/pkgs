{lib}: let
  mkUser = i: {
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
          "\n" (builtins.readFile (builtins.fetchurl {
            url = "${i.githubKeysUrl}";
            sha256 = "${i.sha256}";
          })))
        # arg2
        ;
    };
  };
  mkUsers = users: upstream: {
    # mapped users
    users.users = builtins.listToAttrs (builtins.map mkUser users);

    home-manager = {
      backupFileExtension = "hbak";

      extraSpecialArgs = {
        inputs = upstream.inputs;
        outputs = upstream.outputs;
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
