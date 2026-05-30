{ config, ... }:
{
  age.secrets."wifi-ap-password" = {
    file = ../../secrets/wifi-ap-password.age;
  };

  services.hostapd = {
    enable = true;
    radios.wlan0 = {
      band = "5g";
      channel = 165;
      countryCode = "US";
      networks.wlan0 = {
        ssid = "Dr. Breen's Private Reserve";
        authentication.saePasswords = [{
          passwordFile = config.age.secrets."wifi-ap-password".path;
        }];
      };
      wifi5 = {
        enable = true;
        require = true;
        operatingChannelWidth = "80";
      };
    };
  };
}
