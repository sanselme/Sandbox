// SPDX-License-Identifier: GPL-3.0

use clap::Parser;
use std::{fs, path};

/// Search for a pattern in a file and display the lines that contain it.
#[derive(Parser)]
struct Cli {
    /// The pattern to look for.
    pattern: String,
    /// The path to the file to read.
    path: path::PathBuf,
}

fn main() {
    let args = Cli::parse();
    let content = fs::read_to_string(&args.path).expect("could not read file");

    for line in content.lines() {
        if line.contains(&args.pattern) {
            println!("{line}");
        }
    }
}
