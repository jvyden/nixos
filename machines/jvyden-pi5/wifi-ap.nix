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

  # the actual access point
  services.hostapd = {
    enable = true;
    radios.wlan0 = {
      band = "5g";
      channel = 149; # 36
      countryCode = "US";
      networks.wlan0 = {
        ssid = "Dr. Breen's Private Reserve";
        authentication.saePasswords = [{
          passwordFile = config.age.secrets."wifi-ap-password".path;
        }];
      };
      wifi4 = {
        enable = true;
        capabilities = ["HT40+" "HT40-" "SHORT-GI-20" "SHORT-GI-40" "DSSS_CCK-40"];
      };
      wifi5 = {
        enable = true;
        require = true;
        operatingChannelWidth = "80";
        capabilities = ["SHORT-GI-80" "SU-BEAMFORMEE"];
      };

      settings = {
        vht_oper_centr_freq_seg0_idx = 155; # 42
      };
    };
  };

  # ok, lets set up networking stuff now
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    useDHCP = false;
    interfaces.wlan0 = {
      ipv4.addresses = [{
        address = "10.69.69.1";
        prefixLength = 24;
      }];
    };

    nat = {
      enable = true;
      externalInterface = "end0";
      internalInterfaces = ["wlan0"];
    };

    firewall.interfaces.wlan0.allowedUDPPorts = [ 53 67 ]; # dns, dhcp
  };

  # and now a dhcp server
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wlan0";
      bind-interfaces = true;
      port = 0; # disable DNS server
      dhcp-range = ["10.69.69.100,10.69.69.200,24h"];
      dhcp-option = [ # https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol#Options
        "3,10.69.69.1" # default gateway
        "6,10.69.69.1,1.1.1.1,1.0.0.1" # DNS server
      ];
    };
  };
}
