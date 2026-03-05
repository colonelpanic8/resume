set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

resume_tex := "resume.tex"
resume_pdf := "resume.pdf"

default:
    @just --list

fmt:
    tmp="$(mktemp --suffix=.tex)"; trap 'rm -f "$tmp"' EXIT; latexindent -l -s -c /tmp -o "$tmp" {{resume_tex}}; test -s "$tmp"; mv "$tmp" {{resume_tex}}

fmt-check:
    tmp="$(mktemp --suffix=.tex)"; trap 'rm -f "$tmp"' EXIT; latexindent -l -s -c /tmp -o "$tmp" {{resume_tex}}; diff -u {{resume_tex}} "$tmp"

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
