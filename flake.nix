{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pgpilot-src = {
      url = "github:gfriloux/pgpilot/v0.2.0";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      snowfall = {
        namespace = "pgpilot";
      };
    };
}
