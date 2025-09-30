{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  libxkbcommon,
  openssl,
  pkg-config,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-ollama";
  version = "0-unstable-2025-07-20";

  src = fetchFromGitHub {
    owner = "PhoenixPhantom"; # Use custom fork to prevent the vendoring errors until it's fixed upstream
    repo = "cosmic-ext-applet-ollama";
    rev = "062f8e6a1d27361eefd33ab256381c3d88ee0fb1";
    hash = "sha256-4/d8R3N/b2OfzjJJgmukTLPc/qMCig2G1OlvkSN9KTg=";
  };

  cargoHash = "sha256-ZPc+XnVRmbOs22ODpW51sQjTFC6RaDNuHuxY3MkqIsg=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    just
  ];

  buildInputs = [
    libxkbcommon
    openssl.dev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "targetdir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-ollama";
    description = "Ollama applet for COSMIC Desktop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      #PhoenixPhantom
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-ollama";
  };
}
