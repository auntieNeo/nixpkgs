# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Cabal, lens, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "cabal-lenses";
  version = "0.4";
  sha256 = "19ryd1qvsc301kdpk0zvw89aqhvk26ccbrgddm9j5m31mn62jl2d";
  buildDepends = [ Cabal lens unorderedContainers ];
  jailbreak = true;
  meta = {
    description = "Lenses and traversals for the Cabal library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
