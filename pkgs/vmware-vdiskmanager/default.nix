{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  name = "vmware-vdiskmanager";

  src = pkgs.requireFile {
    name = "1023856-vdiskmanager-linux.7.0.1.zip";
    sha256 = "c34ebf57a9fccdeaf6b989f613e2418bb71894a51e0694b933307cbcbb9d706d";
    message = ''
      Unfortunately, we cannot download this automatically.

      You can either add all relevant files to the nix-store like this:
      nix-store --add-fixed sha256 1023856-vdiskmanager-linux.7.0.1.zip
    '';
  };

  nativeBuildInputs = [ pkgs.unzip autoPatchelfHook ];

  unpackPhase = ''
    mkdir $out
    unzip $src -d $out
  '';

  installPhase = ''
    mkdir $out/bin
    mv $out/1023856-vmware-vdiskmanager-linux.7.0.1 $out/bin/vmware-vdiskmanager
    chmod a+x $out/bin/vmware-vdiskmanager
  '';

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.unfree;
    maintainers = with maintainers; [ simonkampe ];
    platforms = platforms.linux;
  };
}
