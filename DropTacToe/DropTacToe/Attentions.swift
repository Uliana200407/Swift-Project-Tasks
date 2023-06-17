
import SwiftUI
struct AttentionsItem: Identifiable{
    let id = UUID()
    var title: Text
    var buttonTitle: Text
}
struct AttentionsContext{
    static let personWin = AttentionsItem(title:Text("You are the winner!"),
                                   buttonTitle: Text("One more Attempt"))
    static let botWin = AttentionsItem(title:Text("You are the looser!"),
                                   buttonTitle: Text("One more Attempt"))
    static let draw = AttentionsItem(title:Text("That's draw!"),
                                   buttonTitle: Text("One more Attempt"))
}
