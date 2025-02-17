{ flakes, nixConfig, utils, self ? flakes.self }: flakes.yafas.withAllSystems { }
  (universals: { system, ... }:
  let
    pkgs = import flakes.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
    };
  in
  with universals; {
    packages = utils.applyOverlay { inherit pkgs; };
    nixpkgs = pkgs;
    system = flakes.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ self.nixosModules.default ];
    };
  })
{
  inherit nixConfig;
}
