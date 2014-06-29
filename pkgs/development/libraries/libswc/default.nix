{ stdenv, fetchurl, fontconfig, libdrm, libevdev, libwld, libxcb, libxkbcommon, pixman, pkgconfig, udev, wayland, ... }:

stdenv.mkDerivation rec {
  name = "libswc-${version}";
  version = "47eb93bf0c85651f72b6a86b4cab315701d16510";

  src = fetchurl {
    url = "https://github.com/michaelforney/swc/archive/${version}.tar.gz";
    sha256 = "3a1439b97d694ff85755bbd924a9b7d88e3e20b92c8f6c48b1a4fd91bfcb818c";
  };

  buildInputs = [
    fontconfig
    libdrm
    libevdev
    libwld
    libxcb
    libxkbcommon
    pixman
    pkgconfig
    udev
    wayland
  ];

#  makeFlags = "-e PREFIX=\${out}/usr";

  meta = {
    description = "A library for making a simple Wayland compositor";
    homepage = https://github.com/michaelforney/swc;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
