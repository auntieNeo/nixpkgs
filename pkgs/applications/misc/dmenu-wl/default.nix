{ stdenv, fetchurl, fontconfig, libswc, libwld, libxkbcommon, pixman, wayland }:

stdenv.mkDerivation rec {
  name = "dmenu-wl-${version}";
  version = "6e08b77428cc3c406ed2e90d4cae6c41df76341e";

  src = fetchurl {
    url = "https://github.com/michaelforney/dmenu/archive/${version}.tar.gz";
    sha256 = "d0f73e442baf44a93a3b9d41a72e9cfa14f54af6049c90549f516722e3f88019";
  };

  buildInputs = [ fontconfig libswc libwld libxkbcommon pixman wayland ];

  makeFlags = "SWCPROTO=${libswc}/share/swc/swc.xml PREFIX=\${out}";

  preFixup = ''
    # FIXME: I'm not sure if dmenu_run-wl can function without "stest" or "dmenu" in the path.
    # Might need to patch something for correctness.
    for i in dmenu dmenu_path dmenu_run stest; do
      mv $out/bin/$i $out/bin/$i-wl
    done
  '';

  meta = {
    description = "an efficient dynamic menu for swc/wayland";
    homepage = https://github.com/michaelforney/dmenu;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
