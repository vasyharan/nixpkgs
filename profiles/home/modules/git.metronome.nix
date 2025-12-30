{ ... }: {
  programs.git = {
    settings = {
      user = {
        name = "Thirukumaran Vaseeharan";
        email = "haran@metronome.com";
      };
    };
    ignores = [ ".DS_Store" "tf.plan" ".zed/debug.json" ];
  };
  programs.jujutsu = {
    settings = {
      user = {
        name = "Thirukumaran Vaseeharan";
        email = "haran@metronome.com";
      };

      aliases = {
        "fetch" = ["git" "fetch" "-b" "main" "-b" "glob:haran/*"];
      };
    };
  };
}
