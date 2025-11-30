{
  pkgs,
  fetchFromGitHub
}:

pkgs.xeus-zmq.overrideAttrs ( rec {
    version = "3.1.1";
    src = fetchFromGitHub {
      owner = "jupyter-xeus";
      repo = "xeus-zmq";
      rev = "${version}";
      hash = "sha256-7Af+zhz2VSXYwrQPSef/1HBmkhhYPyI1KzzhCkUJ3XY=";
    };
  })
