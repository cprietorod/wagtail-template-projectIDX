# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.gnumake
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
      "dracula-theme.theme-dracula"
    ];
    # Enable previews
    previews = {
      enable = true;
      previews = {
        web = {
          # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
          # and show it in IDX's web preview panel
          command = ["./devserver.sh"];
          manager = "web";
          env = {
            # Environment variables to set for your server
            PORT = "$PORT";
         };
       };
      }; 
    };
    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        create-venv = ''
          python -m venv .venv
          source .venv/bin/activate
          pip install -r requirements.txt  
        '';
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Example: start a background task to watch and re-build backend code
        create-venv = ''
          if [ ! -d .venv ]; then 
            python -m venv .venv
            source $PWD/.venv/bin/activate
            echo "source $PWD/.venv/bin/activate" >> ~/.bashrc
            pip install -r requirements.txt
          fi
          source $PWD/.venv/bin/activate

          if [ ! -d db.sqlite3 ]; then
            python manage.py migrate
            sleep 1
          fi

        '';
        install-oh-my-bash = ''
          if [ ! -d ~/.oh-my-bash ]; then
            git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash
            cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
          fi
        '';
        # watch-backend = "npm run watch-backend";
      };
    };
  };
}
