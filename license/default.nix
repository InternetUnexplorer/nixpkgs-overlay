{ stdenv, lib, fetchFromSourcehut, rustPlatform, scdoc, makeWrapper
, installShellFiles, fzf, xclip }:

# NOTE: After making this I noticed that `license` already includes a Nix
# derivation in `contrib/pkg/nix/license.nix`. However, I think it still makes
# sense to include this one in the overlay just for convenience. Also, since I
# didn't know about the existence of the other overlay until I had written this
# one, this is still licensed under CC-0 (although the two are very similar!).

rustPlatform.buildRustPackage rec {
  pname = "license";
  version = "2.6.1";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "license";
    rev = version;
    hash = "sha256-39W8Jagj656rivWlNWUr7qNeDQtaBdJYUzwYucZhr5o=";
  };

  nativeBuildInputs = [ scdoc makeWrapper installShellFiles ];

  cargoHash = "sha256-G7IISD8qli5Yyf35nKCyiEGluIpNmPtbps5ecjklcug=";

  postInstall = ''
    install -Dm755 scripts/set-license $out/bin/set-license
    install -Dm755 scripts/copy-header $out/bin/copy-header

    wrapProgram $out/bin/set-license \
      --prefix PATH : ${lib.makeBinPath [ "$out" fzf ]}
    wrapProgram $out/bin/copy-header \
      --prefix PATH : ${lib.makeBinPath [ "$out" fzf xclip ]}

    scdoc < doc/license.scd > doc/license.1
    installManPage doc/license.1

    installShellCompletion            \
      --bash completions/license.bash \
      --fish completions/license.fish \
      --zsh completions/_license
  '';

  passthru.exePath = "/bin/license";

  meta = with lib; {
    description = "A tool to easily add a license to your project";
    inherit (src.meta) homepage;
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
