{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mkEspDerivation = f: pkgs.stdenv.mkDerivation (finalAttrs:
          let set = f finalAttrs;
          in {
            inherit (set) pname version installPhase;
            src = pkgs.fetchurl {
              url = "https://github.com/espressif/esp-idf/archive/refs/tags/v${finalAttrs.version}.tar.gz";
              hash = "sha256-1xfZ1CulDdDo08x+w2oYPpbHzOQdsWrTFdWtu4XKlns=";
            };
          });
      in
      {
        name = "esp";
        packages = {
          default = self.packages.${system}.esp_common;
          esp_common = mkEspDerivation (finalAttrs: {
            pname = "esp_common";
            version = "4.3.7";
            installPhase = ''
              mkdir -p $out
              cp -r components/esp_common/* $out
            '';
          });
          xtensa = mkEspDerivation (finalAttrs: {
            pname = "xtensa";
            version = "4.3.7";
            installPhase = ''
              mkdir -p $out
              cp -r components/xtensa/* $out
            '';
          });
          freertos = mkEspDerivation (finalAttrs: {
            pname = "freertos";
            version = "4.3.7";
            installPhase = ''
              mkdir -p $out
              cp -r components/freertos/* $out
            '';
          });
        };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
