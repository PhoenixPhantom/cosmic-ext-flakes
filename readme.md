# cosmic-ext-flakes
This is a nix package set for extensions to System76's COSMIC desktop
environment. 

## Packaged extensions
This package currently provides packages for the following applications:
 * [cosmic-ext-applet-caffeine](https://github.com/tropicbliss/cosmic-ext-applet-caffeine)
 * [cosmic-ext-clippboard-manager](https://github.com/cosmic-utils/clipboard-manager)
 * [cosmic-ext-applet-emoji-selector](https://github.com/leb-kuchen/cosmic-applet-emoji-selector)
 * [cosmic-ext-external-monitor-brightness](https://github.com/cosmic-utils/cosmic-ext-applet-external-monitor-brightness)
 * [cosmic-ext-applet-ollama](https://github.com/elevenhsoft/cosmic-applet-ollama)
 * [cosmic-ext-applet-privacy-indicator](https://github.com/D-Brox/cosmic-ext-applet-privacy-indicator)*
 * [observatory](https://github.com/cosmic-utils/observatory)
   
\* Package currently untested

## Usage

### Flakes

If you have an existing `configuration.nix`, you can use the `cosmic-ext` flake with the following in an adjacent `flake.nix` (e.g. in `/etc/nixos`):


> <picture>
>   <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/info.svg">
>   <img alt="Info" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/info.svg">
> </picture><br>
>
> If switching from traditional evaluation to flakes, `nix-channel` will no longer have any effect on the nixpkgs your system is built with, and therefore `nixos-rebuild --upgrade` will also no longer have any effect. You will need to use `nix flake update` from your flake directory to update nixpkgs and cosmic-ext-flakes.


```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # or "github:nixos/nixpkgs/nixos-unstable"
    cosmic-ext = {
        url = "github:PhoenixPhantom/cosmic-ext-flakes";
        inputs.nixpkgs.follows = "nixpkgs";  # make cosmic-ext use the same version of nixpkgs as the rest of your system
    };
  };

  outputs = { self, nixpkgs, cosmic-ext }: {
    nixosConfigurations = {
      # NOTE: change "host" to your system's hostname
      host = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs = {
              # You can configure nixpkgs here
              # config.allowUnfree = true;
              overlays = [
                cosmic-ext.overlays.default
              ];
            };
          }
          ./configuration.nix
          # other modules to import would go here
        ];
      };
    };
  };
}
```

You can then install the desired package by adding it to `users.users."yourusername".packages`,
`environment.system.packages` or `home.packages` (only if using home manager).

### COSMIC Utilities - Observatory not working

The monitord service must be enabled to use Observatory.

```nix
systemd.packages = [ pkgs.observatory ];
systemd.services.monitord.wantedBy = [ "multi-user.target" ];
`
