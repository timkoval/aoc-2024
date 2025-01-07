{
  description = "A C++ template using cmake for nix";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "template";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
          ];

          buildInputs = [];

          cmakeFlags = [];

        };

        devShells.default = pkgs.mkShell.override {
          stdenv = pkgs.clangStdenv;
        } rec {
          buildInputs = with pkgs; [
            clang-tools
            just
            stdenv.cc.cc
            cmake
            clang
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

          shellHook = ''
          export PATH="${pkgs.clang-tools}/bin:$PATH"
          ''; 
        };
      }
    )
    // {
      overlays.default = self: pkgs: {
        hello = self.packages."${pkgs.system}".hello;
      };
    };
}
