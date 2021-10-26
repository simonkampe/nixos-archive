import <nixpkgs> {
  overlays = [
    (self: super: {
      vmware-vdiskmanager = import "./vmware-vdiskmanager/";
    })
  ];
}
