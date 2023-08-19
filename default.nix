{ stdenv, lib, fetchurl, dpkg, autoPatchelfHook, cups }:
let
  debPlatform =
    if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386"
         else throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "fflinuxprint";
  version = "1.1.3-4";

  src = fetchurl {
    url = "https://support-fb.fujifilm.com/driver_downloads/fflinuxprint_1.1.3-4_amd64.deb";
    sha256 = "434a81e20bc459ad74286b7a4a7815aab6b115e3f1210eb69d3ac5678e2fcab5";
    curlOpts = "--user-agent Mozilla/5.0";  # HTTP 410 otherwise
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ cups ];

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc $out
    mv usr/lib $out

    mkdir -p $out/share/cups/model
    mv usr/share/ppd/fujifilm/* $out/share/cups/model
  '';

  meta = with lib; {
    description = "FujiFILM Linux Printer Driver";
    longDescription = ''
    Linux PDF Print Driver.
    Operating Systems: GNU / Linux, Linux, Linux 64 bit
    Products: Apeos 2560, Apeos 3060, Apeos 3560, Apeos 4570, Apeos 4830, Apeos 5330, Apeos 5570, Apeos 6340, Apeos 6580, Apeos 7580, Apeos C2060, Apeos C2560, Apeos C3060, Apeos C3070, Apeos C325 dw, Apeos C325 z, Apeos C328 df, Apeos C328 df(정부조달품목), Apeos C328 dw, Apeos C3530, Apeos C3570, Apeos C4030, Apeos C4570, Apeos C5240, Apeos C5570, Apeos C6570, Apeos C6580, Apeos C7070, Apeos C7580, Apeos C8180, ApeosPort 2560, ApeosPort 3060, ApeosPort 3560, ApeosPort 4570, ApeosPort 5570, ApeosPort C2060, ApeosPort C2560, ApeosPort C3060, ApeosPort C3070, ApeosPort C3570, ApeosPort C4570, ApeosPort C5570, ApeosPort C6570, ApeosPort C7070, ApeosPort Print C5570, ApeosPort-VI C2271, ApeosPort-VI C3370, ApeosPort-VI C3371, ApeosPort-VI C4471, ApeosPort-VI C5571, ApeosPort-VI C6671, ApeosPort-VI C7771, ApeosPort-VII 4021, ApeosPort-VII 5021, ApeosPort-VII C2273, ApeosPort-VII C3321, ApeosPort-VII C3372, ApeosPort-VII C3373, ApeosPort-VII C4421, ApeosPort-VII C4473, ApeosPort-VII C5573, ApeosPort-VII C5588, ApeosPort-VII C6673, ApeosPort-VII C6688, ApeosPort-VII C7773, ApeosPort-VII C7788, ApeosPrint 3360S, ApeosPrint 3960S, ApeosPrint 4560S, ApeosPrint 5330, ApeosPrint 6340, ApeosPrint C325 dw, ApeosPrint C328, ApeosPrint C328 dw, ApeosPrint C328 dw(정부조달품목), ApeosPrint C4030, ApeosPrint C5240, ApeosPrint C5570, ApeosPro C650, ApeosPro C750, ApeosPro C810, DocuCentre SC2022, DocuCentre-VI C2271, DocuCentre-VI C3370, DocuCentre-VI C3371, DocuCentre-VI C4471, DocuCentre-VI C5571, DocuCentre-VI C6671, DocuCentre-VI C7771, DocuCentre-VII C2273, DocuCentre-VII C3372, DocuCentre-VII C3373, DocuCentre-VII C4473, DocuCentre-VII C5573, DocuCentre-VII C5588, DocuCentre-VII C6673, DocuCentre-VII C6688, DocuCentre-VII C7773, DocuCentre-VII C7788, DocuPrint 3205 d, DocuPrint 3208 d, DocuPrint 3505 d, DocuPrint 3508 d, DocuPrint 4405 d, DocuPrint 4408 d, DocuPrint C5155 d, DocuPrint CM315 z, DocuPrint CM318 z, DocuPrint CP315 dw, DocuPrint CP318 dw, DocuPrint CP475, DocuPrint P365 d, DocuPrint P368 d, DocuPrint P475, Revoria Press E1100, Revoria Press E1110, Revoria Press E1125, Revoria Press E1136


    '';
    homepage = "https://support-fb.fujifilm.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
