{ pkgs }:
let
  xeus-zmq-3_1_1 = pkgs.callPackage ./xeus-zmq.nix {};
in

{
  xeus-octave = pkgs.callPackage ./package.nix {
    xeus-zmq = xeus-zmq-3_1_1;
  };

}
