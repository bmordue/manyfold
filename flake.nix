{
  description = "Nix flake for the Manyfold project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.ruby
            pkgs.bundler
            pkgs.nodejs
            pkgs.redis
            pkgs.postgresql
          ];

          shellHook = ''
            export BUNDLE_PATH=$PWD/.bundle
            export GEM_HOME=$PWD/.gem
            export PATH=$GEM_HOME/bin:$PATH
            bundle install
            yarn install
          '';
        };

        packages = {
          manyfold = pkgs.stdenv.mkDerivation {
            name = "manyfold";
            src = ./.;
            buildInputs = [
              pkgs.ruby
              pkgs.bundler
              pkgs.nodejs
              pkgs.redis
              pkgs.postgresql
            ];

            buildPhase = ''
              bundle install --path $out
              yarn install
            '';

            installPhase = ''
              mkdir -p $out
              cp -r . $out
            '';
          };
        };

        defaultPackage.x86_64-linux = self.packages.${system}.manyfold;
      }
    );
}
