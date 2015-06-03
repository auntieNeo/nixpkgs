{ stdenv, buildPythonPackage, fetchurl, pythonPackages }:

let 
  # Some of the package version constraints for git-review are stupid, so we
  # derive those packages here rather than in python-packages.nix
  #
  # Note: I am aware that some of these package versions are already defined
  # inside python-packages.nix.

  hacking_0_9_5 = buildPythonPackage rec {
    name = "hacking-${version}";
    version = "0.9.5";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/h/hacking/hacking-${version}.tar.gz";
      sha256 = "000vav7dqgmb26vhbpqqksn6mv7yj5vj9c116xzgnmqq3jgnc420";
    };

    # Version requirements for flake8 are impossible to satisfy
    doCheck = false;

    buildInputs = with pythonPackages; [ discover_0_4_0 flake8_2_1_0 pbr pip six
      pep8_1_5_6
    ];
  };

  pep8_1_5_6 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.5.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      sha256 = "06h4pzj7c5d0xsny9p9nrf0nvx2r07s74f8gmx263b6sz29fk2qs";
    };
  };

  pyflakes_0_8_1 = buildPythonPackage rec {
    name = "pyflakes-0.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      md5 = "905fe91ad14b912807e8fdc2ac2e2c23";
    };

    buildInputs = with pythonPackages; [ unittest2 ];

    doCheck = false;
  };

  flake8_2_1_0 = buildPythonPackage (rec {
    name = "flake8-2.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      md5 = "cf326cfb88a1db6c5b29a3a6d9efb257";
    };

    buildInputs = with pythonPackages; [ nose mock ];
    propagatedBuildInputs = with pythonPackages; [ pyflakes_0_8_1 pep8_1_5_6 mccabe ];

    # 3 failing tests
    #doCheck = false;
  });

  # Specific version of flake8 to satisfy the requirements of hacking-0.9.5
  flake8_2_2_4 = buildPythonPackage (rec {
    name = "flake8-${version}";
    version = "2.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      sha256 = "1r9wsry4va45h1rck5hxd3vzsg2q3y6lnl6pym1bxvz8ry19jwx8";
    };

    buildInputs = with pythonPackages; [ nose mock ];
    propagatedBuildInputs = with pythonPackages; [ pyflakes_0_8_1 pep8_1_5_6 mccabe ];
  });

  discover_0_4_0 = buildPythonPackage rec {
    name = "discover-${version}";
    version = "0.4.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/d/discover/discover-${version}.tar.gz";
      sha256 = "0y8d0zwiqar51kxj8lzmkvwc3b8kazb04gk5zcb4nzg5k68zmhq5";
    };
  };
in
buildPythonPackage rec {
  name = "git-review-${version}";
  version = "1.24";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/g/git-review/git-review-${version}.tar.gz";
    sha256 = "0aji5zdwkbd9390hrikhzw3dw2r7vmqgfw62ac8v8c34p3j8pyi0";
  };

  doCheck = false;

  buildInputs = with pythonPackages; [ discover_0_4_0 hacking_0_9_5 pbr pip pyflakes_0_8_1 flake8_2_1_0
    pep8_1_5_6 six testrepository testtools
  ];
  propagatedBuildInputs = with pythonPackages; [ requests ];
}
