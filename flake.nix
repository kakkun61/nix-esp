{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        name = "esp";
        packages = {
          default = self.packages.${system}.esp_common;
          esp_common = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "esp_common";
            version = "4.3.7";
            src = pkgs.fetchurl {
              url = "https://github.com/espressif/esp-idf/archive/refs/tags/v${finalAttrs.version}.tar.gz";
              hash = "sha256-1xfZ1CulDdDo08x+w2oYPpbHzOQdsWrTFdWtu4XKlns=";
            };
            installPhase = ''
              mkdir -p $out
              cp -r components/esp_common/* $out
            '';
          });
          xtensa = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "esp_common";
            version = "4.3.7";
            src = pkgs.fetchurl {
              url = "https://github.com/espressif/esp-idf/archive/refs/tags/v${finalAttrs.version}.tar.gz";
              hash = "sha256-1xfZ1CulDdDo08x+w2oYPpbHzOQdsWrTFdWtu4XKlns=";
            };
            installPhase = ''
              mkdir -p $out
              cp -r components/xtensa/* $out
            '';
          });
        };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
