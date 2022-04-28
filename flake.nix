{
  description = "Arash's github.io";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem ["x86_64-linux"]
      (system:
        let
          pkgs = import nixpkgs { system = system; };
          gems = pkgs.bundlerEnv {
            name = "arashsm79.github.io-bundlerEnv";
            ruby = pkgs.ruby;
            gemdir = ./.;
          };
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              gems
              gems.wrappedRuby
              bundix
            ];
          };
        }
      );
}
