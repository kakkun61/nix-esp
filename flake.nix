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
            inherit (set) pname installPhase;
            version = "5.1.2";
            src = pkgs.fetchurl {
              url = "https://github.com/espressif/esp-idf/archive/refs/tags/v${finalAttrs.version}.tar.gz";
              hash = "sha256-CrgaiegSQshcwTlBkk9o7LkccwMMN61h/jkLOcLVQYI=";
            };
          });
      in
      {
        name = "esp";
        packages = {
          default = self.packages.${system}.esp_common;
          esp_common = mkEspDerivation (finalAttrs: {
            pname = "esp_common";
            installPhase = ''
              mkdir -p $out
              cp -r components/esp_common/* $out
            '';
          });
          xtensa = mkEspDerivation (finalAttrs: {
            pname = "xtensa";
            installPhase = ''
              mkdir -p $out
              cp -r components/xtensa/* $out
            '';
          });
          freertos = mkEspDerivation (finalAttrs: {
            pname = "freertos";
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
