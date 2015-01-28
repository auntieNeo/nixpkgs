# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Cabal, Decimal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.4.4";
  sha256 = "16knk1cwrpg5jn6vgcab7hqpjzg33ysz57x1f2glrmhhv1slmbfn";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal Decimal hledgerLib mtl time ];
  meta = {
    homepage = "http://github.com/peti/hledger-interest";
    description = "computes interest for a given account";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ simons ];
  };
})
