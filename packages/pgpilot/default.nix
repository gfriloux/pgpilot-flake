{
  pkgs,
  lib,
  inputs,
  ...
}:
# Fully static linking is not achievable for this GUI app: gtk3 (rfd) and
# vulkan-loader/libGL (iced/wgpu) are inherently dynamic. The binary is built
# with glibc and wrapped so that all runtime libs are resolved from the Nix
# store — no manual LD_LIBRARY_PATH setup needed.
let
  runtimeLibs = with pkgs; [
    wayland
    libxkbcommon
    libGL
    vulkan-loader
    dbus
  ];
in
pkgs.rustPlatform.buildRustPackage {
  pname = "pgpilot";
  version = "0.6.0";

  src = inputs.pgpilot-src;

  cargoLock.lockFile = "${inputs.pgpilot-src}/Cargo.lock";

  nativeBuildInputs = with pkgs; [
    pkg-config
    clang
    makeWrapper
  ];

  buildInputs = with pkgs; [
    nettle
    gmp
    gtk3
    dbus
    wayland
    libxkbcommon
    libGL
    vulkan-loader
    libx11
    libxcursor
    libxrandr
    libxi
  ];

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

  postInstall = ''
    wrapProgram $out/bin/pgpilot \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}

    install -Dm644 share/applications/pgpilot.desktop \
      $out/share/applications/pgpilot.desktop
    install -Dm644 share/icons/hicolor/scalable/apps/pgpilot.svg \
      $out/share/icons/hicolor/scalable/apps/pgpilot.svg
  '';

  meta = {
    description = "PGP key manager GUI built with iced";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "pgpilot";
  };
}
