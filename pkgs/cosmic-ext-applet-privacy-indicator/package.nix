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
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "D-Brox";
    repo = "cosmic-ext-applet-privacy-indicator";
    rev = "2d3b0efec5a95cf704e414f6e3005641f3aa3666";
    hash = "sha256-iTdCn5IbOs+g9MeC+EDUGSYxlHTrmhouvL7Y6Y3rK/M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Tbcjnbjyo+FoYtRe5KnPiEzV+1PkzHOnbVDRe/pJul0=";

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
      PhoenixPhantom
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-privacy-indicator";
  };
}
