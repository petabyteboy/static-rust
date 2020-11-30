{ pkgs }:

with pkgs;

mkDevShell {
  name = "static-rust";
  motd = "Welcome to static rust";

  bash = {
    extra = ''
      unset GOPATH GOROOT
      export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
      export LD_LIB_PATH="$DEVSHELL_DIR/lib"
    '';
    interactive = ''
    '';
  };

  env = {
    DATABASE_URL="postgresql://todomvc_dbuser:todomvc_dbpass@localhost:5432/todomvc_db";
    PGHOST="localhost";
    PGPORT="5432";
    PGDATABASE="todomvc_db";
    PGUSER="todomvc_dbuser";
    PGPASSWORD="todomvc_dbpass";
    PKG_CONFIG_ALLOW_CROSS="true";
    PKG_CONFIG_ALL_STATIC="true";
    LIBZ_SYS_STATIC="1";
    OPENSSL_STATIC="1";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_STATIC="1";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR="${pkgsMusl.openssl.dev}";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR = "${pkgsMusl.openssl.dev}/lib";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR = "${pkgsMusl.openssl.dev}/include";
    x86_64_UNKNOWN_LINUX_MUSL_PKG_CONFIG_PATH = "${pkgsMusl.pkgconfig}";
    TARGET="musl";
  };

  packages = [
    ### Rust
	rizary.rust
    # ### Others
    pkgsMusl.pkgconfig
    pkgsMusl.cacert
    pkgsMusl.openssl.dev
    pkgsMusl.openssl
    pkgsMusl.glibc
    pkgsMusl.musl.dev
    pkgsMusl.zlib.static
    gmp5.static
    # database
    postgresql
  ];
}
