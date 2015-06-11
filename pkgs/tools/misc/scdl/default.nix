{ stdenv, fetchgit, python34Packages }:

python34Packages.buildPythonPackage rec {
  name = "scdl-${version}";
  version = "1.3";

  src = fetchgit {
    url = https://github.com/flyingrub/scdl.git;
    rev = "refs/tags/v${version}";
    sha256 = "81332e4decdd4e69636520c2817182559a625ca34f094946c1bc81c46fd823d3";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    sed -i 's|@scdl_cfg@|'"$out"'/share/scdl/scdl.cfg.default|g' \
      ./scdl/__init__.py
  '';

  doCheck = true;

  buildInputs = with python34Packages; [ pip ];
  propagatedBuildInputs = with python34Packages; [ fudge_1_0_3 docopt mutagen soundcloud termcolor wget ];

  postInstall = ''
    wrapProgram "$out"/bin/scdl \
      --run 'mkdir -p $HOME/.config/scdl' \
      --run 'cp -n '"$out"'/share/scdl/scdl.cfg.default $HOME/.config/scdl/scdl.cfg' \
      --run 'chmod 0600 $HOME/.config/scdl/scdl.cfg'
  '';
}
