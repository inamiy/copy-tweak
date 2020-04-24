import Foundation

func tweak(_ string: String) -> String {
    string
        |> tweak_trello_url
        |> tweak_screen_shot_markdown
}

/// Trims Trello's redundant "title + \n + url" format.
func tweak_trello_url(_ string: String) -> String {
    string
        .replacingOccurrences(
            of: #"([\s\S])https://trello.com/c/(.+?)/[0-9]+.*[^\)\}\]]"#,
            with: "$1https://trello.com/c/$2",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: #" on .* \| Trello"#,
            with: "",
            options: .regularExpression
        )
}

/// Trims Quiver's auto-inserted markdown image-alt.
func tweak_screen_shot_markdown(_ string: String) -> String {
    string.replacingOccurrences(
        of: #"\!\[Screen Shot .+? at .+?\]"#,
        with: "![]",
        options: .regularExpression
    )
}

//----------------------------------------

let string = CommandLine.arguments.dropFirst().joined(separator: " ")
print(tweak(string), terminator: "")
