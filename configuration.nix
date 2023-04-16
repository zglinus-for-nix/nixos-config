# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cfw.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi"; # 默认是 /boot，重点就是改这里

    grub = {
      enable = true;
      device = "nodev";
      default = "1"; # 从0计数
      efiSupport = true;

      # osprober 会自动检测 windows 或其它系统并生成配置
      # 经常输出无关信息，我现在不用了
      #useOSProber = true;

      # 不用 osprober，自己手动添加启动项
      extraEntries = ''
        menuentry "Windows" {
         search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
         chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/data" =
    {
      device = "/dev/disk/by-uuid/EAD76BE3764DDD03";
      fsType = "ntfs";
    };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };



  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.enableTCP = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.theme = "sugar-candy";

  # Configure keymap in X11
  services.xserver = {
    layout = "cn";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zgl = {
    isNormalUser = true;
    description = "zgl";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      kate
      #  thunderbird
    ];
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode"
      "nvidia-offload"
      "nvidia-x11"
      "nvidia-settings"
      "clash-for-windows"
      "obsidian"
      "steam-run"
      "steam-original"
      "wpsoffice"
      "vivaldi"
      "widevine"
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vscode
    nvidia-offload
    zsh
    git
    git-lfs
    nodejs
    ffmpeg
    vlc
    simplescreenrecorder
    speedcrunch
    python310
    xorg.xhost
    zsh-powerlevel10k
    powerline-fonts
    rnix-lsp
    # obsidian
    meson
    filelight
    # vivaldi
    # vivaldi-widevine
    # vivaldi-ffmpeg-codecs
    #(pkgs.callPackage ./user/cfw.nix { })
    (pkgs.callPackage ./user/obsidian.nix { })
    #(pkgs.callPackage ./user/watt-toolkit.nix { })
    (libsForQt5.callPackage ./user/latte-dock.nix { })
    (libsForQt5.callPackage ./user/wps.nix { })
    (pkgs.callPackage ./user/sddm.nix { })
  ];

  fonts.fonts = [
    (pkgs.callPackage ./user/fonts.nix { })
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the AMD GPU. You can find it using lspci, either under 3D or VGA
    amdgpuBusId = "PCI:6:0:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

  };
  hardware.nvidia.forceFullCompositionPipeline = true;

  # Bluetooth setting
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio.extraConfig = "
  load-module module-switch-on-connect
  ";

  # zsh setting
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
  };
  programs.zsh.ohMyZsh.custom = "~/.config/zsh/scripts";
  users.users.zgl.shell = pkgs.zsh;


  virtualisation.docker = {
    enable = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
