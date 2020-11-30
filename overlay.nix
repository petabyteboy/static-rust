final: prev:
{
  rizary = rec {
    rust = prev.callPackage ./rust { };
    myRustPlatform = prev.makeRustPlatform {
      cargo = rust;
      rustc = rust;
    };
    static-rust = myRustPlatform.buildRustPackage rec {
        pname = "rust-backend";
        version = "0.0.1";

        src = ./.;
        cargoSha256 = "sha256-2JdmF9iQ+rVQs/yVuCHnryHx7GOiuYGCooc6kDq9k9Q=";

        RUSTC_BOOTSTRAP=1;
        PKG_CONFIG_ALLOW_CROSS=true;
        PKG_CONFIG_ALL_STATIC=true;

        LIBZ_SYS_STATIC=1;
        X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_STATIC=1;
        PKG_CONFIG_PATH_x86_64_UNKNOWN_LINUX_MUSL = "${prev.pkgsMusl.pkgconfig}";
        X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR="${prev.pkgsMusl.openssl.dev}";
        X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR = "${prev.pkgsMusl.openssl.dev}/lib";
        X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR = "${prev.pkgsMusl.openssl.dev}/include";
        x86_64_UNKNOWN_LINUX_MUSL_PKG_CONFIG_PATH = "${prev.pkgsMusl.pkgconfig}";
        PQ_LIB_STATIC_X86_64_UNKNOWN_LINUX_MUSL=1;


        TARGET="musl";
        target="x86_64-unknown-linux-musl";
        # Needed to get openssl-sys to use pkgconfig.
        # OPENSSL_NO_VENDOR = 1;
        doCheck = false;

        nativeBuildInputs = [
          prev.pkgsMusl.pkgconfig
          prev.pkgsMusl.glibc
          prev.pkgsMusl.musl.dev
          prev.pkgsMusl.zlib.static
          prev.openssl
          prev.openssl.dev
        ];

        buildInputs = [
          prev.openssl
          prev.openssl.dev
          prev.postgresql
        ];
    };
  };
}
