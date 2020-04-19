precedencegroup infixl0 {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: infixl0

func |> <A, B>(a: A, f: (A) -> B) -> B {
    f(a)
}
