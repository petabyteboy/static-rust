final: prev:
let
  zlibStatic = prev.pkgsStatic.zlib;
  nasslOpensslArgs = {
    static = true;
    enableSSL2 = true;
  };
  nasslOpensslFlagsCommon = [
    "zlib"
    "no-zlib-dynamic"
    "no-shared"
    "--with-zlib-lib=${zlibStatic.out}/lib"
    "--with-zlib-include=${zlibStatic.out.dev}/include"
    "enable-rc5"
    "enable-md2"
    "enable-gost"
    "enable-cast"
    "enable-idea"
    "enable-ripemd"
    "enable-mdc2"
    "-fPIC"
  ];
in
{
  rizary = rec {
    opensslStatic = (prev.openssl.override nasslOpensslArgs).overrideAttrs (
      oldAttrs: rec {
        name = "openssl-${version}";
        version = "1.1.1";
        src = prev.fetchurl {
          url = "https://www.openssl.org/source/${name}.tar.gz";
          sha256 = "0gbab2fjgms1kx5xjvqx8bxhr98k4r8l2fa8vw7kvh491xd8fdi8";
        };
        configureFlags = oldAttrs.configureFlags ++ nasslOpensslFlagsCommon ++ [
          "enable-weak-ssl-ciphers"
          "enable-tls1_3"
          "no-async"
        ];
        patches = [ ./nix-ssl-cert-file.patch ];
        buildInputs = oldAttrs.buildInputs ++ [ zlibStatic prev.cacert ];
      }
    );
    rust = prev.callPackage ./rust { };
    myRustPlatform = prev.makeRustPlatform prev.rustPackages_1_45;
    static-rust = myRustPlatform.buildRustPackage rec {
        pname = "rust-backend";
        version = "0.0.1";

        src = ./.;
        cargoSha256 = "sha256-31MviNz6i3lK5BEs7zgWteWCMkSFnZIQprkmeecAVRk=";

        # RUSTC_BOOTSTRAP=1;
        # PKG_CONFIG_ALLOW_CROSS=true;
        # PKG_CONFIG_ALL_STATIC=true;

        # LIBZ_SYS_STATIC=1;
        # OPENSSL_STATIC=1;
        # OPENSSL_DIR="${opensslStatic.out.dev}";
        # X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR = "${opensslStatic.out}/lib";
        # X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR = "${opensslStatic.out.dev}/include";
        # PKG_CONFIG_PATH = "${prev.pkgsStatic.pkg-config}";
        CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER = "${prev.buildPackages.llvmPackages_10.lld}/bin/lld";
        # CC="${prev.musl.dev}/bin/musl-gcc";
        # PQ_LIB_STATIC_X86_64_UNKNOWN_LINUX_MUSL=1;


        TARGET="musl";
        target="x86_64-unknown-linux-musl";
        # Needed to get openssl-sys to use pkgconfig.
        # OPENSSL_NO_VENDOR = 1;
        doCheck = false;

        nativeBuildInputs = [
          prev.pkgsStatic.pkg-config
        #   prev.glibc
        #   prev.pkgsMusl.glibc
        #   prev.musl.dev
        #   zlibStatic
        #   opensslStatic
        #   opensslStatic.dev
        #   prev.pkgsMusl.pkgconfig
        #   prev.pkgsMusl.glibc
        #   prev.pkgsMusl.musl.dev
        #   prev.pkgsMusl.zlib.static
        #   prev.openssl
        #   prev.openssl.dev
        ];

        buildInputs = [
        #   prev.pkgsStatic.glibc
        #   prev.pkgsMusl.glibc
        #   opensslStatic
        #   opensslStatic.dev
        #   prev.postgresql
        ];
    };
  };
}
