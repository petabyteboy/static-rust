{ pkgs }:

with pkgs;

mkDevShell {
  name = "static-rust";
  motd = "Welcome to static rust";

  commands = [{
      name = "go_openssl";
      help = "start psql service";
      command = "ls -lah ${musl.dev}/bin || echo '''PG start failed''' ";
  }];

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
    CC="${musl.dev}/bin/musl-gcc";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_STATIC="1";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR="${rizary.opensslStatic.bin}/bin";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR = "${rizary.opensslStatic.out}/lib";
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR = "${rizary.opensslStatic.out.dev}/include";
    x86_64_UNKNOWN_LINUX_MUSL_PKG_CONFIG_PATH = "${pkgsStatic.pkg-config}";
    TARGET="musl";
  };

  packages = [
    ### Rust
	rizary.rust
    # ### Others
    pkgsStatic.pkg-config
    pkgsStatic.cacert
    rizary.opensslStatic.dev
    rizary.opensslStatic
    # pkgsStatic.glibc
    musl.dev
    pkgsStatic.zlib
    gmp5.static
    # database
    postgresql
  ];
}
