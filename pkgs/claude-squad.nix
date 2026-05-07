{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  tmux,
  gh,
}:

buildGoModule rec {
  pname = "claude-squad";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "smtg-ai";
    repo = "claude-squad";
    tag = "v${version}";
    hash = "sha256-eZY4CpzHBfkLbkfEpqoZqlk33cB0uVKx9zW3UC8kYiE=";
  };

  vendorHash = "sha256-Rc0pIwnA0k99IKTvYkHV54RxtY87zY1TmmmMl+hYk6Q=";

  # Tests shell out to git/tmux/gh, which aren't available in the build sandbox.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Upstream's install.sh renames the binary to `cs`; match that so docs work.
    mv $out/bin/claude-squad $out/bin/cs
    wrapProgram $out/bin/cs \
      --prefix PATH : ${lib.makeBinPath [ tmux gh ]}
  '';

  meta = {
    description = "Terminal app to manage multiple Claude Code / Aider / Codex / Amp sessions in parallel";
    homepage = "https://github.com/smtg-ai/claude-squad";
    license = lib.licenses.agpl3Only;
    mainProgram = "cs";
    platforms = lib.platforms.unix;
  };
}
