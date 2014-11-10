# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, Cabal, convertible, dataDefault, deepseq, djinnGhc
, doctest, emacs, filepath, ghcPaths, ghcSybUtils, haskellSrcExts
, hlint, hspec, ioChoice, makeWrapper, monadControl, monadJournal
, mtl, split, syb, temporary, text, time, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "5.2.0.0";
  sha256 = "1zwdr3zlnc8d49d6jrvj2yrfnamp1120gffzd6vfxqgvapk71vfk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    async Cabal convertible dataDefault deepseq djinnGhc filepath
    ghcPaths ghcSybUtils haskellSrcExts hlint ioChoice monadControl
    monadJournal mtl split syb temporary text time transformers
    transformersBase
  ];
  testDepends = [
    Cabal convertible deepseq djinnGhc doctest filepath ghcPaths
    ghcSybUtils haskellSrcExts hlint hspec ioChoice monadControl
    monadJournal mtl split syb temporary text time transformers
    transformersBase
  ];
  buildTools = [ emacs makeWrapper ];
  doCheck = false;
  configureFlags = "--datasubdir=${self.pname}-${self.version}";
  postInstall = ''
    cd $out/share/$pname-$version
    make
    rm Makefile
    cd ..
    ensureDir "$out/share/emacs"
    mv $pname-$version emacs/site-lisp
    wrapProgram $out/bin/ghc-mod --add-flags \
      "\$(${self.ghc.GHCGetPackages} ${self.ghc.version} \"\$(dirname \$0)\" \"-g -package-db -g\")"
    wrapProgram $out/bin/ghc-modi --add-flags \
      "\$(${self.ghc.GHCGetPackages} ${self.ghc.version} \"\$(dirname \$0)\" \"-g -package-db -g\")"
  '';
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
    description = "Happy Haskell Programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [
      andres bluescreen303 ocharles
    ];
  };
})
