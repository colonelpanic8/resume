{
  description = "Resume build environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            collection-fontsrecommended
            collection-latexextra
            fontawesome5
            moderncv
            scheme-medium
            xetex
            ;
        };

        resume = pkgs.stdenvNoCC.mkDerivation {
          pname = "resume";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [
            tex
          ];

          buildPhase = ''
            runHook preBuild
            latexmk -pdfxe -interaction=nonstopmode -file-line-error -halt-on-error resume.tex
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p "$out"
            cp resume.pdf "$out/"
            runHook postInstall
          '';
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.just
            tex
          ];
        };

        packages = {
          default = resume;
          resume = resume;
        };

        checks.resume = resume;
      }
    );
}
