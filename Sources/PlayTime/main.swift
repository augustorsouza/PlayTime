import PlayTimeCore

let tool = PlayTime()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
