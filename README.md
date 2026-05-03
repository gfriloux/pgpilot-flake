# pgpilot-flake

A Nix flake that packages [pgpilot](https://github.com/gfriloux/pgpilot) and
provides a home-manager module for it.

pgpilot is a PGP key manager GUI built with [iced](https://github.com/iced-rs/iced).
It uses [sequoia-openpgp](https://sequoia-pgp.org/) as its cryptographic backend.

**Supported systems:** `x86_64-linux`, `aarch64-linux`

---

## Usage

### Option 1 — Direct install with nix profile

Install pgpilot into your user profile without touching your existing
configuration:

```sh
nix profile install github:gfriloux/pgpilot-flake#pgpilot
```

### Option 2 — home-manager module

This flake exposes a home-manager module that adds pgpilot to your user
packages when enabled.

#### 1. Add the flake as an input

In your home-manager flake's `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pgpilot-flake = {
      url = "github:gfriloux/pgpilot-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, pgpilot-flake, ... }: {
    homeConfigurations."youruser" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        pgpilot-flake.homeModules.pgpilot
        ./home.nix
      ];
    };
  };
}
```

#### 2. Enable the module in your home configuration

In your `home.nix`:

```nix
{
  pgpilot.pgpilot.enable = true;
}
```

Activating this option adds the `pgpilot` binary to `home.packages`.

---

## Updating pgpilot

The pgpilot source is pinned via the `pgpilot-src` flake input. To pull a
newer version, update only that input:

```sh
nix flake update pgpilot-src
```

Then rebuild your profile or home-manager configuration as usual. Note that
after updating the input you may also need to adjust the `version` field in
`packages/pgpilot/default.nix` if the upstream release tag changes.

---

## License

Apache-2.0. See [LICENSE](LICENSE).
