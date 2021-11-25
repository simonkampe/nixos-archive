{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  name = "vmware-vdiskmanager";

  src = pkgs.requireFile {
    name = "VMware-vix-disklib-7.0.3-18705163.x86_64.tar.gz";
    sha256 = "d7cffd87dc806dccaa267e48008d5b3a4fbea56fc24701e93676659583f92bb6";
    message = ''
      Unfortunately, we cannot download this automatically.

      You can add all relevant files to the nix-store like this:
      nix-store --add-fixed sha256 VMware-vix-disklib-7.0.3-18705163.x86_64.tar.gz
    '';
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir $out/bin
    mv bin64/vmware-vdiskmanager $out/bin/
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
