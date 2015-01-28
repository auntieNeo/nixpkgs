{ stdenv, fetchurl, libevdev, mtdev, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libinput-${version}";
  version = "0.7.0";
  # NOTE: version 0.8.0 isn't used because the removal of the
  # libinput_event_pointer_get_axis symbol currently breaks libswc (2015-01-27)

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/libinput-${version}.tar.xz";
    sha256 = "129f485afe5e4a9394641293991c97cb99f5f3338340d0d65b704ff463d1579e";
  };

  buildInputs = [ libevdev mtdev pkgconfig udev ];

  meta = {
    description = "Library to handle input devices in Wayland compositors";
    homepage = http://www.freedesktop.org/wiki/Software/libinput/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
