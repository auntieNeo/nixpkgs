# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, hspec, hspecExpectationsLens, htmlConduit, lens
, text, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "xml-html-conduit-lens";
  version = "0.3.2.1";
  sha256 = "0iy58nq5b6ixdky2xr4r8xxk3c8wqp1y3jbpsk3dr1qawzjbzp12";
  buildDepends = [ htmlConduit lens text xmlConduit ];
  testDepends = [
    doctest hspec hspecExpectationsLens lens xmlConduit
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/supki/xml-html-conduit-lens#readme";
    description = "Optics for xml-conduit and html-conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
