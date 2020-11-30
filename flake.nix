{
  description = "todomvc-nix";
  # To update all inputs:
  # $ nix flake update --recreate-lock-file
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell/master";
  inputs.naersk.url = "github:nmattia/naersk";
  # Only for example, use the .url for simplicity
  inputs.mozilla-overlay = {
    type = "github";
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    flake = false;
  };

  # Haskell dependencies
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";

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

          packages = flake-utils.lib.flattenTree;

          devShell = import ./shell.nix { inherit pkgs; };

          checks = { };
        }
      )
    );
}
