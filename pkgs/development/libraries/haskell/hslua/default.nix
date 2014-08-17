# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, lua, mtl }:

cabal.mkDerivation (self: {
  pname = "hslua";
  version = "0.3.13";
  sha256 = "02j3hrzq3dgcv4bvf4xz14qxvzlb0vlxrf7lk9wqwdy43b978mz9";
  buildDepends = [ mtl ];
  pkgconfigDepends = [ lua ];
  configureFlags = "-fsystem-lua";
  meta = {
    description = "A Lua language interpreter embedding in Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
