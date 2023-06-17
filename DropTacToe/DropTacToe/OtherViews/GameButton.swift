

import SwiftUI

struct GameButton: View {
    let title: String
    let background: Color
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .frame(width: 300, height: 50)
            .background(background)
            .foregroundColor(Color.black)
            .cornerRadius(20)    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameButton(title: "Play", background : .red)
    }
}
