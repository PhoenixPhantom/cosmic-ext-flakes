{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pkg-config,
  libclang,
  glibc,
  clang-tools,
  llvmPackages,
  just,
  pipewire,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-privacy-indicator";
  version = "0.2.0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "D-Brox";
    repo = "cosmic-ext-applet-privacy-indicator";
    rev = "e69833cf8b31813d5468da7eeea6311f1621d702";
    hash = "sha256-LivssKbrzAO4kuoNcE6evs4etaiFgH0UWeOSzHtgd1A=";
  };

  cargoHash = "sha256-Ul17dBobjheF4wUFx/leb0XkyXjqBdOfM41e4yBYHio=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    just
  ];

  LIBCLANG_PATH="${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${libclang.lib}/lib/clang/${lib.versions.major (lib.getVersion libclang)}/include -isystem ${glibc.dev}/include";

  buildInputs = [
    pipewire.dev
    glibc.dev
    clang-tools
    libclang.lib
    # llvmPackages.libcxxClang
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-privacy-indicator"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-privacy-indicator";
    description = "Privacy indicator for the COSMIC DE";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      #PhoenixPhantom
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-privacy-indicator";
  };
}
