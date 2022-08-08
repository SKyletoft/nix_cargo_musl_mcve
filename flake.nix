{
	description = "";

	inputs = {
		nixpkgs.url     = "github:nixos/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem(system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
			in rec {
				mcve = pkgs.rustPlatform.buildRustPackage {
					pname              = "mcve";
					version            = "0.0.1";
					src                = self;
					cargoSha256        = "sha256-ah8IjShmivS6IWL3ku/4/j+WNr/LdUnh1YJnPdaFdcM=";
					cargoLock.lockFile = "${self}/Cargo.lock";
					buildInputs        = with pkgs; [ musl ];
				};
				defaultPackage = mcve;
				devShell = pkgs.mkShell {
					buildInputs       = mcve.buildInputs;
					nativeBuildInputs = with pkgs; [
						rustup
					] ++ mcve.nativeBuildInputs;
				};
			}
		);
}
