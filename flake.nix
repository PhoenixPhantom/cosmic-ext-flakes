# flake.nix
{
   inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

      rust-overlay = {
         url = "github:oxalica/rust-overlay";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-compat = {
         url = "github:nix-community/flake-compat";
         flake = false;
      };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, rust-overlay, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      rustPlatformFor =
        pkgs:
        if nixpkgs.lib.versionAtLeast pkgs.rustc.version "1.85.0" then
          pkgs.rustPlatform
        else
          let
            rust-bin = rust-overlay.lib.mkRustBin { } pkgs;
          in
          pkgs.makeRustPlatform {
            cargo = rust-bin.stable.latest.default;
            rustc = rust-bin.stable.latest.default;
            cargo-auditable =
              if nixpkgs.lib.versionAtLeast pkgs.cargo-auditable.version "0.6.5" then
                pkgs.cargo-auditable
              else
                pkgs.cargo-auditable.overrideAttrs (attrs: { meta = attrs.meta // { broken = true; }; });
          };
    in
    {
       lib = {
          packagesFor =
             pkgs:
             import ./pkgs {
                inherit pkgs;
                rustPlatform = rustPlatformFor pkgs;
             };
       };

       packages = forAllSystems (system: self.lib.packagesFor nixpkgs.legacyPackages.${system});

       overlays = {
          default =
             final: prev:
             import ./pkgs {
                inherit final prev;
                rustPlatform = rustPlatformFor prev;
             };
       };
    };
}
