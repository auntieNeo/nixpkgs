# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, filemanip, primitive }:

cabal.mkDerivation (self: {
  pname = "fixed-vector";
  version = "0.7.0.0";
  sha256 = "07wpzcpnnz0jjq5gs4ra8c2hyrxzmp0ryk06y3ryf8i4w65awgvf";
  buildDepends = [ primitive ];
  testDepends = [ doctest filemanip primitive ];
  meta = {
    description = "Generic vectors with statically known size";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
