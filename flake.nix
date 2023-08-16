{
  description = "FFLinuxPrint NixOS Flake";

  outputs = { self, nixpkgs }: {

defaultPackage.x86_64-linux = 
with import nixpkgs {system = "x86_64-linux"; } ;
stdenv.mkDerivation {
  pname = "fflinuxprint";
  version = "1.1.3-4";

  src = fetchurl {
    url = "https://support-fb.fujifilm.com/driver_downloads/fflinuxprint_1.1.3-4_amd64.deb";
    hash = "sha256-Q0qB4gvEWa10KGt6SngVqraxFePxIQ62nTrFZ44vyrU=";
    curlOpts = "--user-agent Mozilla/5.0";  # HTTP 410 otherwise
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ cups ];

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;


  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/cups/model
    mv {etc,usr/lib} $out
    mv usr/share/ppd/fujifilm/* $out/share/cups/model

    runHook postInstall
  '';

  meta = with lib; {
    description = "FujiFILM Linux Printer Driver";
    longDescription = '''';
    homepage = "https://support-fb.fujifilm.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jaduff ];
    platforms = platforms.linux;
  };
};
};
}
