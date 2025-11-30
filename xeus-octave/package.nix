{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libuuid,
  xeus-zmq,
  xeus,
  nlohmann_json,
  openssl,
  octave,
  glfw
}:

stdenv.mkDerivation rec {
  pname = "xeus-octave";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "theNextUsername";
    repo = "xeus-octave";
    rev = "25730a24069d8fc9a448c1732eee8f08042bc558";
    sha256 = "sha256-7kH2BI7DZI2C8TMIZh25R2y1Unx1h5EARBxL0H2G5rs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    pkg-config
    zlib
    libpng
    libuuid
    xeus-zmq
    xeus
    nlohmann_json
    openssl
    octave
    glfw
  ];
}

