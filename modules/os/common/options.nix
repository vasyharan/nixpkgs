{ config, lib, options, ... }:
let inherit (lib) mkAliasDefinitions mkOption types;
in {
  options = {
    user = mkOption {
      type = types.attrs;
      default = { };
    };
    home = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = {
    users.users.${config.user.name} = mkAliasDefinitions options.user;
    home-manager.users.${config.user.name} = mkAliasDefinitions options.home;
  };
}
