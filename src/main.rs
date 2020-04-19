extern crate clipboard;

mod error;

use self::error::Error;
use clipboard::{ClipboardContext, ClipboardProvider};
use std::env;
use std::process::Command;
use std::thread;
use std::time::Duration;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args: Vec<String> = env::args().collect::<Vec<String>>();
    args.remove(0);

    let (cmd_program, cmd_args) = args
        .split_first()
        .ok_or(Error("No arguments.".to_owned()))?;

    let mut clipboard: ClipboardContext = ClipboardProvider::new()?;
    let mut is_initial = true;
    let mut prev_string: String = "".to_owned();

    loop {
        let current_string = clipboard.get_contents()?;
        let mut is_tweaked = false;

        if current_string != prev_string {
            if is_initial {
                is_initial = false;
            } else {
                let mut args = cmd_args.to_owned();
                args.push(current_string.to_owned());

                let tweaked_string = run_command(&cmd_program, &args)?;

                if tweaked_string.len() > 0 && tweaked_string != current_string {
                    clipboard.set_contents(tweaked_string.clone())?;
                    println!("Tweaked! (updated clipboard)\n");

                    // Set `tweaked_string` as a new state so that
                    // it prevents from repeated `set_contents` -> `get_contents` loop.
                    prev_string = tweaked_string;
                    is_tweaked = true;
                } else {
                    println!("No tweaks (no updates in clipboard)\n");
                }
            }
        }

        if !is_tweaked {
            prev_string = current_string;
        }

        let millis = Duration::from_millis(1000);
        thread::sleep(millis);
    }
}

fn run_command(program: &str, args: &[String]) -> Result<String, Box<dyn std::error::Error>> {
    let mut command = Command::new(program);
    let command = command.args(args);
    println!("command: {:?}", command);

    let output = command.output()?;
    let output_string = String::from_utf8(output.stdout)?;
    println!("output: {}", output_string);

    Ok(output_string)
}
