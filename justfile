set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

resume_tex := "resume.tex"
resume_pdf := "resume.pdf"

default:
    @just --list

build:
    latexmk -pdfxe -interaction=nonstopmode -file-line-error -halt-on-error {{resume_tex}}

watch:
    latexmk -pdfxe -pvc -interaction=nonstopmode -file-line-error {{resume_tex}}

clean:
    latexmk -C {{resume_tex}}

distclean: clean
    rm -f {{resume_pdf}}

nix-build:
    nix build .#resume

nix-check:
    nix flake check
