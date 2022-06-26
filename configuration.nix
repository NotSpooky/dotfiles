# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Costa_Rica";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.satori = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    youtube-dl
    python3
    git
    dmd
    dub
    chromium
    qpdf
    mpv-with-scripts
    krita
    mediainfo
    exfat
    ntfs3g
    ffmpeg
    bats
    obs-studio
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv-with-scripts.override {
        # scripts = [ self.mpvScripts.<your choice> ];
        scripts = [];
      };
    })
  ];

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
	      nnoremap ; :
        nnoremap : :! clear && 
    	  cmap qq q!
        cmap ww w !sudo tee %
	      set hlsearch
        set incsearch
	      set expandtab tabstop=2 shiftwidth=2 softtabstop=2
        set scrolloff=5
        set number relativenumber
        set ignorecase smartcase
        set pastetoggle=<F2>
        set autochdir
        set mouse=a
        set colorcolumn=80
        highlight ColorColumn ctermbg=7
	      nnoremap ñ :tabe .<CR>
	      " I hate ex mode.
	      map Q <Nop>
      '';
      packages.nix = with pkgs.vimPlugins; {
        start = [
          easymotion
	        neomru
	        asyncomplete-vim
	      ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    #shellAliases = {
    #  ll = "ls -l";
    #  dup = "gnome-terminal --window &!";
    #  yt = "youtube-dl -F ";
    #  ytr = "youtube-dl -f";
    #  q = "exit";
    #  pc = "nautilus &!";
    #  update = "sudo nix-channel update && sudo nixos-rebuild switch";
    #  clean = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch";
    #};
    interactiveShellInit = ''
      # History searching.
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search # Up
      bindkey "^[[B" down-line-or-beginning-search # Down
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;6D" forward-word

      # Shell aliases doesn't seem to be working
      alias ll='ls -l'
      alias dup='gnome-terminal --window &!';
      alias yt='yt-dlp -F ';
      alias ytf='yt-dlp -f ';
      alias q='exit';
      alias pc='nautilus &!';
      alias update='sudo nix-channel update && sudo nixos-rebuild switch';
      alias clean='sudo nix-collect-garbage -d && sudo nixos-rebuild switch';
      
    '';
    setOptions = [
      "AUTO_CD"
      "MENU_COMPLETE"
      "HIST_FIND_NO_DUPS"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "NO_HUP"
    ];
    histSize = 10000;
  };

  users.defaultUserShell = pkgs.zsh;

  environment.variables.EDITOR = "nvim";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  services.flatpak.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

