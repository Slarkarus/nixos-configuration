{ config, pkgs, ... }:

{
    imports =
        [
        ./hardware-configuration.nix
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    # Mount a hard disk
    fileSystems."/mnt/mydrive" = {
        device = "/dev/disk/by-uuid/1274A7D374A7B83D";
        fsType = "ntfs";
        options = [ "defaults" "nofail" ]; # 'nofail' prevents boot issues
    };

    networking.hostName = "carbon"; # Define your hostname.

    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Moscow";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
    hardware.nvidia = {
        open = false;
        powerManagement.enable = false;

        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Add working with .envrc files
    programs.direnv.enable = true;

    programs.nix-ld.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        jack.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.slarkarus = {
        isNormalUser = true;
        description = "slarkarus";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            thunderbird
            vlc
            vscode
            v2raya
            telegram-desktop
            zoom-us
            discord
            code-cursor
            
            openvpn
            networkmanager-openvpn
        ];
    };

    services.v2raya = {
        enable = true;
        cliPackage = pkgs.xray; 
    };

    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        gitFull
        wget
        curl
    ];

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
            PasswordAuthentication = true;
            AllowUsers = [ "slarkarus" ];
            UseDns = true;
            PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        };
    };

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    programs.ssh.startAgent = true;

    system.stateVersion = "25.05"; 
}
