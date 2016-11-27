{ stdenv, lib, fetchFromGitHub, fetchurl, fetchgit, jdk, ant
, libusb, libusb1, unzip, zlib, ncurses, readline
, upx, fontconfig, xorg, gcc, xdotool, xvfb_run
, withGui ? false, gtk2 ? null, withTeensyduino ? false
}:

assert withGui -> gtk2 != null;

let
  externalDownloads = import ./downloads.nix {inherit fetchurl; inherit (lib) optionalAttrs; inherit (stdenv) system;};
  # Some .so-files are later copied from .jar-s to $HOME, so patch them beforehand
  patchelfInJars =
       lib.optional (stdenv.system == "x86_64-linux") {jar = "share/arduino/lib/jssc-2.8.0.jar"; file = "libs/linux/libjSSC-2.8_x86_64.so";}
    ++ lib.optional (stdenv.system == "i686-linux") {jar = "share/arduino/lib/jssc-2.8.0.jar"; file = "libs/linux/libjSSC-2.8_x86.so";}
  ;
  # abiVersion 6 is default, but we need 5 for `avrdude_bin` executable
  ncurses5 = ncurses.override { abiVersion = "5"; };
in
stdenv.mkDerivation rec {
  version = "1.6.12";
  name = "${if (withTeensyduino == true) then "teensyduino" else "arduino"}${stdenv.lib.optionalString (withGui == false) "-core"}-${version}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "0rz8dv1mncwx2wkafakxqdi2y0rq3f72fr57cg0z5hgdgdm89lkh";
  };

#  teensyduino_src = fetchgit {
#    url = https://github.com/PaulStoffregen/cores.git;
#    rev = "refs/tags/1.31";
#    sha256 = "0p9ikapklsfv29v8kywgw70wgc1h5iibcxbpc4jj2dij8cy5l3h0";
#  };

  teensyduino_src = fetchurl {
    url = "http://www.pjrc.com/teensy/td_131/TeensyduinoInstall.linux64";
    sha256 = "1q4wv6s0900hyv9z1mjq33fr2isscps4q3bsy0h12wi3l7ir94g9";
  };

  teensyduino_libpath = stdenv.lib.makeLibraryPath [
    fontconfig
    zlib
    xorg.libXext
    xorg.libX11
    xorg.libXft
    gcc.cc.lib
  ];

  buildInputs = [ jdk ant libusb libusb1 unzip zlib ncurses5 readline
    upx xvfb_run
  ];
  downloadSrcList = builtins.attrValues externalDownloads;
  downloadDstList = builtins.attrNames externalDownloads;

  buildPhase = ''
    # Copy pre-downloaded files to proper locations
    download_src=($downloadSrcList)
    download_dst=($downloadDstList)
    while [[ "''${#download_src[@]}" -ne 0 ]]; do
      file_src=''${download_src[0]}
      file_dst=''${download_dst[0]}
      mkdir -p $(dirname $file_dst)
      download_src=(''${download_src[@]:1})
      download_dst=(''${download_dst[@]:1})
      cp -v $file_src $file_dst
    done


    cd ./arduino-core && ant
    cd ../build && ant 
    cd ..
  '';

  # This will be patched into `arduino` wrapper script
  # Java loads gtk dynamically, so we need to provide it using LD_LIBRARY_PATH
  dynamicLibraryPath = lib.makeLibraryPath [gtk2];
  javaPath = lib.makeBinPath [jdk];

  # Everything else will be patched into rpath
  rpath = (lib.makeLibraryPath [zlib libusb libusb1 readline ncurses5 stdenv.cc.cc]);

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/" #*/
    echo ${version} > $out/share/arduino/lib/version.txt

    ${stdenv.lib.optionalString withGui ''
      mkdir -p $out/bin
      substituteInPlace $out/share/arduino/arduino \
        --replace "JAVA=java" "JAVA=$javaPath/java" \
        --replace "LD_LIBRARY_PATH=" "LD_LIBRARY_PATH=$dynamicLibraryPath:"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"

      cp -r build/shared/icons $out/share/arduino
      mkdir -p $out/share/applications
      cp build/linux/dist/desktop.template $out/share/applications/arduino.desktop
      substituteInPlace $out/share/applications/arduino.desktop \
        --replace '<BINARY_LOCATION>' "$out/bin/arduino" \
        --replace '<ICON_NAME>' "$out/share/arduino/icons/128x128/apps/arduino.png"
    ''}


    ${stdenv.lib.optionalString (withTeensyduino == true) "
    # Patch the teensyduino installer elf file
    cp ${teensyduino_src} ./TeensyduinoInstall.linux64
    chmod +w ./TeensyduinoInstall.linux64
    upx -d ./TeensyduinoInstall.linux64
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \\
        --set-rpath \"$teensyduino_libpath\" \\
        ./TeensyduinoInstall.linux64
    chmod +x ./TeensyduinoInstall.linux64
    echo $(cat $NIX_CC/nix-support/dynamic-linker)
    echo \"$teensyduino_libpath\"
    export HOME=$out/share/arduino
    xvfb-run ./TeensyduinoInstall.linux64
    DISPLAY=:99 xdotool search --class \"teensyduino\" \\
      windowfocus \\
      key space sleep 1 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key space sleep 1 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key Tab sleep 0.4 \\
      key space sleep 1 \\
      key Tab sleep 0.4 \\
      key space sleep 35
    ls -lR .
    false
    # Copy teensyduino files to the libraries directory
    find ${teensyduino_src} -mindepth 1 -maxdepth 1 -type d \\
      -exec cp -rv '{}' ./libraries \\;
    "}
    pwd
    ls -lh .
    ls -lh ./libraries
  '';

  # So we don't accidentally mess with firmware files
  dontStrip = true;
  dontPatchELF = true;

  preFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/lib $file || true
    done

    ${lib.concatMapStringsSep "\n"
        ({jar, file}:
          ''
              jar xvf $out/${jar} ${file}
              patchelf --set-rpath $rpath ${file}
              jar uvf $out/${jar} ${file}
              rm -f ${file}
          ''
        )
        patchelfInJars}

    # avrdude_bin is linked against libtinfo.so.5
    mkdir $out/lib/
    ln -s ${lib.makeLibraryPath [ncurses5]}/libncursesw.so.5 $out/lib/libtinfo.so.5
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ antono robberer bjornfor ];
  };
}
