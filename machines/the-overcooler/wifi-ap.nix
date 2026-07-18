{ config, pkgs, ... }:
{
  age.secrets."wifi-ap-password" = {
    file = ../../secrets/wifi-ap-password.age;
  };

  # helpful debug tools
  environment.systemPackages = with pkgs; [
    iw
    wavemon
  ];

  # remove the card from anything that could control it
  networking.wireless.interfaces = [ ];
  networking.networkmanager.unmanaged = [ "wlp6s0" ];

  # the actual access point
  services.hostapd = {
    enable = true;
    radios.wlp6s0 = {
      band = "6g";
      channel = 69;
      countryCode = "DE";
      noScan = true;
      driver = "nl80211";
      networks.wlp6s0 = {
        ssid = "Dr. Breen's Private Reserve";
        authentication.saePasswords = [
          {
            passwordFile = config.age.secrets."wifi-ap-password".path;
          }
        ];
        settings = {
          # Security
          wpa_key_mgmt = "SAE";
          ieee80211w = 2;
          wme_enabled = 1;
          wmm_enabled = 1;
        };
      };
      wifi4 = {
        enable = true;
        capabilities = [
          "LDPC"
          "HT40+"
          "GF"
          "SHORT-GI-20"
          "SHORT-GI-40"
          "TX-STBC"
          "RX-STBC1"
          "MAX-AMSDU-7935"
        ];
      };
      wifi5 = {
        enable = true;
        require = false;
        operatingChannelWidth = "160";
        capabilities = [
          "VHT160"
          "RXLDPC"
          "SHORT-GI-80"
          "SHORT-GI-160"
          "TX-STBC-2BY1"
          "SU-BEAMFORMEE"
          "MU-BEAMFORMEE"
          "RX-ANTENNA-PATTERN"
          "TX-ANTENNA-PATTERN"
          "RX-STBC-1"
          "BF-ANTENNA-4"
          "MAX-MPDU-11454"
          "MAX-A-MPDU-LEN-EXP7"
        ];
      };
      wifi6 = {
        enable = true;
        require = true;
        operatingChannelWidth = "160";
        singleUserBeamformer = false;
        singleUserBeamformee = false;
        multiUserBeamformer = false;
      };

      settings = {
        # vht_oper_centr_freq_seg0_idx = 155; # 42
        op_class = 134;
        country3 = "0x49";
        he_oper_chwidth = 2;
        he_6ghz_reg_pwr_type = 2; # Very low power AP (default)
        he_oper_centr_freq_seg0_idx = 79;
        he_6ghz_max_mpdu = 2;
        he_6ghz_max_ampdu_len_exp = 7;
      };
    };
  };

  # ok, lets set up networking stuff now
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    useDHCP = false;
    interfaces.wlp6s0 = {
      ipv4.addresses = [
        {
          address = "10.69.69.1";
          prefixLength = 24;
        }
      ];
    };

    nat = {
      enable = true;
      externalInterface = "enp8s0";
      internalInterfaces = [ "wlp6s0" ];
    };

    firewall.interfaces.wlp6s0.allowedUDPPorts = [
      53 # dns
      67 # dhcp
    ];
  };

  # and now a dhcp server
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "wlp6s0";
      bind-interfaces = true;
      port = 0; # disable DNS server
      dhcp-range = [ "10.69.69.100,10.69.69.200,24h" ];
      dhcp-option = [
        # https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol#Options
        "3,10.69.69.1" # default gateway
        "6,1.1.1.1,1.0.0.1" # DNS server
      ];
    };
  };
}
