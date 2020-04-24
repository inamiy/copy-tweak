use regex::Regex;

fn main() {
    let mut args: Vec<String> = std::env::args().collect::<Vec<String>>();
    args.remove(0);
    let raw = args.join(" ");
    let tweaked = tweak(&raw);
    print!("{}", tweaked);
}

fn tweak(str: &str) -> String {
    let str = tweak_trello_url(&str);
    let str = tweak_screen_shot_markdown(&str);
    str
}

//----------------------------------------

/// Trims Trello's redundant "title + \n + url" format.
fn tweak_trello_url<'a>(str: &'a str) -> String {
    let re = Regex::new(r"([\s\S]*)https://trello.com/c/(.+?)/[0-9]+.*[^\)\}\]]").unwrap();
    let str = re.replace_all(&str, "${1}https://trello.com/c/${2}");

    let re = Regex::new(r" on .*? \| Trello").unwrap();
    let str = re.replace_all(&str, "");

    str.to_string()
}

#[test]
fn test_tweak_trello_url() {
    assert_eq!(
        tweak_trello_url(
            "Some Card Title on Some Trello Project | Trello
https://trello.com/c/deadbeef/427-%E3%83%AD%E3%83%BC%E3%83%AC%E3%83%A0%E3%82%A4%E3%83%97%E3%82%B5%E3%83%A0"
        ),
        "Some Card Title
https://trello.com/c/deadbeef"
    );
}

//----------------------------------------

/// Trims Quiver's auto-inserted markdown image-alt.
fn tweak_screen_shot_markdown<'a>(str: &'a str) -> String {
    let re = Regex::new(r"!\[Screen Shot .+? at .+?\]").unwrap();
    let str = re.replace_all(&str, "![]");
    str.to_string()
}

#[test]
fn test_tweak_screen_shot_markdown() {
    assert_eq!(
        tweak_screen_shot_markdown(
            "![Screen Shot 2020-04-17 at 23.47.53.png](quiver-image-url/2D544807186FF31F6EC294FBB17E3359.png =758x438)"
        ),
        "![](quiver-image-url/2D544807186FF31F6EC294FBB17E3359.png =758x438)"
    );
}
