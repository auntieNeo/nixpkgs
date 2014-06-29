{ stdenv, fetchurl, doxygen, python }:

stdenv.mkDerivation rec {
  name = "libevdev-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/libevdev-${version}.tar.xz";
    sha256 = "860e9a1d5594393ff1f711cdeaf048efe354992019068408abbcfa4914ad6709";
  };

  buildInputs = [
    doxygen
    python
  ];

  meta = {
    description = "A wrapper library for evdev devices";
    homepage = http://www.freedesktop.org/wiki/Software/libevdev/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}

