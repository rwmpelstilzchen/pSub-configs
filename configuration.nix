# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
    ];

  # This should be move to the hardware configuration file
  boot.kernelModules = [ "tp_smapi" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];

  boot.extraKernelParams = [ "quiet" ];
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Set LUKS device
  boot.initrd.luks.devices = [
    { name = "luksroot"; 
      device = "/dev/sda2"; 
      preLVM = true; 
    }
  ];

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "brauchli"; # Define your hostname.
  networking.wireless.enable = false;  # Enables Wireless.
  networking.networkmanager.enable = true;

  # Power Management
  powerManagement.cpuFreqGovernor = "conservative";

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  fileSystems."/".device = "/dev/mapper/vgroup-root";
  fileSystems."/boot".device = "/dev/sda1";

  # List swap partitions activated at boot time.
  swapDevices =
    [ { device = "/dev/mapper/vgroup-swap"; }
    ];

  users.extraUsers.pascal = {
    createHome = true;
    createUser = true;
    description = "Pascal Wittmann";
    group = "users";
    home = "/home/pascal";
    shell = "/var/run/current-system/sw/bin/zsh";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # List services that you want to enable:

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbVariant = "nodeadkeys";
  services.xserver.displayManager.slim.enable = true;
  services.xserver.displayManager.slim.autoLogin = true;
  services.xserver.displayManager.slim.defaultUser = "pascal";
  services.xserver.startGnuPGAgent = true;
  services.xserver.startOpenSSHAgent = false;

  environment = {
    systemPackages = with pkgs; [
      unison
      git
      htop
      zsh

      # Emacs
      emacs24
      emacs24Packages.org
      emacs24Packages.autoComplete
      emacs24Packages.haskellMode
      emacs24Packages.magit
      emacs24Packages.scalaMode

      # Xutils
      xclip

      # Fonts
      inconsolata
      gentium
      dejavu_fonts

      # Misc
      haskellPackages.AgdaExecutable
    ];

    etc = {
      # This link is used to esablish compatibility to Arch.
      certificates = {
        source = "${pkgs.cacert}/etc/ca-bundle.crt";
        target = "ssl/certs/ca-certificates.crt";
      };
    };
  };
}