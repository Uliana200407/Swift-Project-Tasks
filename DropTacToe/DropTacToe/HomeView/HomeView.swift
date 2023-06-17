

import SwiftUI
struct HomeView: View {
    enum SoundOptions:String{
        case Click
        case attentionSounds
    }
    @StateObject var viewModel = HomeViewModel()
    var body: some View {

            VStack{
                Button{
                    SoundManager.instance.playSound(sound: .Click )
                    viewModel.isGameViewPresented = true
                }label:{
                    GameButton(title: "Play", background: Color(.orange))
                }
            }
            .fullScreenCover(isPresented: $viewModel.isGameViewPresented)
            { GameView()
            }
        }
    }

struct GameButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
