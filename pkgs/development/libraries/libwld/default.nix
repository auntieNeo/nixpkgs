{ stdenv, fetchurl, fontconfig, libdrm, pixman, pkgconfig, wayland, ... }:

stdenv.mkDerivation rec {
  name = "libwld-${version}";
  version = "9ed43c65430ef0c18aa659e5f389d9cc3f7ec8d4";

  src = fetchurl {
    url = "https://github.com/michaelforney/wld/archive/${version}.tar.gz";
    sha256 = "32033dbd032f1c4b0ad7d78254daa66e785d9183d41c462b5053405cbacab4d5";
  };

  buildInputs = [
    fontconfig
    libdrm
    pixman
    pkgconfig
    wayland
  ];

  makeFlags = "-e PREFIX=\${out}/usr";

  meta = {
    description = "A primitive drawing library targeted at Wayland";
    homepage = https://github.com/michaelforney/wld;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
