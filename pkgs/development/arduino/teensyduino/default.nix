{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "teensyduino-${version}";
  version = "1.31";

  src = fetchgit {
    url = https://github.com/PaulStoffregen/cores.git;
    rev = "refs/tags/1.31";
    sha256 = "0p9ikapklsfv29v8kywgw70wgc1h5iibcxbpc4jj2dij8cy5l3h0";
  };

  buildPhase = ''
    ls -rl .
  '';
}
