{ stdenv }:

rec {
  name = "wld-$version";
  version = '9ed43c65430ef0c18aa659e5f389d9cc3f7ec8d4';

  pkg = fetchurl {
    url = "https://github.com/michaelforney/wld/archive/$version.tar.gz";
    sha256 = '32033dbd032f1c4b0ad7d78254daa66e785d9183d41c462b5053405cbacab4d5';
  };

  buildInputs = [
    libdrm
    fontconfig
    pixman
    pkgconfig
    wayland
  ];
}
