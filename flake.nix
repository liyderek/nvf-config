{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    # Use the upstream notashelf/nvf flake. Previously attempted to pin
    # to a 'maximal' ref, but that ref may not exist — use the default
    # remote (no explicit ref) so flake fetches the repository's default
    # branch instead.
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nvf,
    self,
    ...
  }: {
    # Expose the upstream 'maximal' prebuilt neovim package as our
    # flake output. This uses the prebuilt configuration from the
    # notashelf/nvf input instead of attempting to import its module.
    packages.x86_64-linux.derek-neovim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          # Or move this to a separate file and add it's path here instead
          # IE: ./nvf_module.nix
          ./nvf_module.nix
        ];
      }).neovim;
    # packages.x86_64-linux.derek-neovim = nvf.packages.x86_64-linux.maximal;
  };
}
