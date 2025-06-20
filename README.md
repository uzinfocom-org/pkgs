<p align="center">
    <img src=".github/assets/header.png" alt="Uzinfocom's {Pack}">
</p>

<p align="center">
    <h3 align="center">Set of helpful packages written by & for Uzinfocom.</h3>
</p>

<p align="center">
    <img align="center" src="https://img.shields.io/github/languages/top/uzinfocom-org/pkgs?style=flat&logo=nixos&logoColor=ffffff&labelColor=242424&color=242424" alt="Top Used Language">
    <a href="https://github.com/uzinfocom-org/pkgs/actions/workflows/test.yml"><img align="center" src="https://img.shields.io/github/actions/workflow/status/uzinfocom-org/pkgs/test.yml?style=flat&logo=github&logoColor=ffffff&labelColor=242424&color=242424" alt="Test CI"></a>
</p>

## About

This repository actually used to be within our [nix configuration for instances](https://github.com/uzinfocom-org/instances). Later, we decided to move all exportable packages, overlays and libs to other repository for lighter input result and more community use. Feel free to use them, feel free to send PR and add your own packages if you feel like.

## Adding repository

This is certainly easiest and yet the very beginning of using our repository with your nix configurations! In order to do that, open your flake configuration in your favorite editor of choice, and then locate for `inputs`. You may have either called each `inputs` seperately like that:

```nix
  inputs.nixpkgs.url = "...";
  inputs.nixpkgs-unstable.url = "...";
  ...
```

or nested it like that:

```nix
  inputs = {
    nixpkgs.url = "...";
    nixpkgs-unstable.url = "...";
  };
```

If you used seperate calls, please, go with nested one, because it will you more convenience when it comes to aligning nixpkgs dependencies to avoid having multiple nixpkgs instances, in a few words, it will be more readable. So, now inside your inputs, do it like that:

```nix
  inputs = {
    nixpkgs.url = "...";
    nixpkgs-unstable.url = "...";
    ...

    # You may copy/paste the code below!
    uzinfocom-pkgs = {
      url = "github:uzinfocom-org/pkgs";
      inputs = {
        # For everything
        nixpkgs.follows = "nixpkgs";
        # For `unstable` overlay
        # If you have unstable in your inputs!!!
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };

  };
```

## Packages

- [Force Push](./packages/force-push/default.nix): do force push using your github bearer token
- [Google](./packages/google/default.nix): start googling right from your terminal

Packages can be used via `nix run` by calling it's names. You can refer to this example shown below:

```shell
# Names are always lowercase spaced with '-'
nix run github:uzinfocom-org/pkgs#<name-here>
```

Or, simply use our `additions` overlay [(refer to this for more)](#overlays) in your nixpkgs configuration and then feel free to add our packages to your nix configs like that:

```nix
  environment.systemPackages = with pkgs; [
    google
    krisper
  ];
```

## Lib

We have a few useful functions initially created for ourselves to abstract certain things in our nix configurations. However, later I decided to ship it as a library which you can easily add to `lib` just by mergeng our lib to your nixpkgs lib as following:

```nix
  # Nixpkgs, Home-Manager and uzinfocom's helpful functions
  lib = nixpkgs.lib // home-manager.lib // uzinfocom-pkgs.lib;
```

## Overlays

Repository includes many useful overlays which enables you to manipulate your `pkgs` instance delivered from `nixpkgs`. You may call & use them something like that:

```nix
# First, localte where you defined nixpkgs configurations
{
  # Alright, this starts like that...
  nixpkgs = {
    # If there's no overlays array, define it yourself!
    overlays = [
      # If you already have overlays, there will be some here
      ...
      # Then, from new line, call our overlays
      inputs.uzinfocom-pkgs.overlays.additions
      inputs.uzinfocom-pkgs.overlays.<name>
    ];
  };
}
```

You may obtain list of available overlays either from [overlays/default.nix](./overlays/default.nix) or refer to this list (might be outdated):

- [Additions](./overlays/additions.nix): merging our packages to your `pkgs` instance, so you can call them within pkgs right away.
- [Modifications](./overlays/modifications.nix): some modifications for pre-existing pkgs delivered from your `inputs.nixpkgs`.
- [Unstable](./overlays/unstable.nix): Binding unstable nixpkgs channel to `pkgs.unstable` variable for calling unstable packages.

## Thanks

- [Template](https://github.com/xinux-org/templates) - Started with this template
- [Nix](https://nixos.org/) - Masterpiece of package management

## License

This project is licensed under the MIT License - see the [LICENSE](license) file for details.

<p align="center">
    <img src=".github/assets/footer.png" alt="Uzinfocom's {Pack}">
</p>
