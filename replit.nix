{ pkgs }: {
    deps = [
        pkgs.gawk
				pkgs.nodejs-16_x # Required to run the LSP
    ];
}