{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    self,
    ...
  }: {
    # This will make the package available as a flake output under 'packages'
    packages.x86_64-linux.derek-neovim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          # Or move this to a separate file and add it's path here instead
          # IE: ./nvf_module.nix
          ./nvf_module.nix
        ];
      })
      .neovim;
  };
}
