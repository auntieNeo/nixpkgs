# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, resourcePool, servant, time }:

cabal.mkDerivation (self: {
  pname = "servant-pool";
  version = "0.1";
  sha256 = "0if4lxb0fpdd4lnkz9j7z6vhjbrcc80pvz9jb6sdb9p6sbbgqf69";
  buildDepends = [ resourcePool servant time ];
  meta = {
    homepage = "http://github.com/zalora/servant-pool";
    description = "Utility functions for creating servant 'Context's with \"context/connection pooling\" support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
