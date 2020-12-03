{
  description = "todomvc-nix";
  # To update all inputs:
  # $ nix flake update --recreate-lock-file
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
  };
  inputs.devshell = {
      url = "github:numtide/devshell/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
  };

  inputs.naersk = {
      url = "github:nmattia/naersk";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
  };
  # Only for example, use the .url for simplicity
  inputs.mozilla-overlay = {
    url = "github:mozilla/nixpkgs-mozilla";
    flake = false;
  };

  outputs = { self, nixpkgs, naersk, mozilla-overlay, flake-utils, devshell }:
    {
      overlay = import ./overlay.nix;
    }
    //
    (
      flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            # Makes the config pure as well. See <nixpkgs>/top-level/impure.nix:
            config = {
                allowBroken = true;
                permittedInsecurePackages = [
                  "openssl-1.0.2u"
                ];
            };
            # crossOverlays = [ (import "${nixpkgs}/pkgs/top-level/static.nix") ];
            crossSystem = {
                isStatic = true;
                config = "x86_64-unknown-linux-musl";
            };
            overlays = [
                (import mozilla-overlay)
                devshell.overlay
                naersk.overlay
                self.overlay
             ];
          };
        in
        {
          legacyPackages = pkgs.rizary;

          defaultPackage = pkgs.rizary.static-rust;

          packages = flake-utils.lib.flattenTree pkgs.rizary;

          devShell = import ./devshell.nix { inherit pkgs; };

          checks = { };
        }
      )
    );
}
