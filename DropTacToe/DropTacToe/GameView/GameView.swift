
import SwiftUI
import AVKit
class SoundManager: ObservableObject{
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    enum SoundOptions:String{
        case Click
        case attentionSounds
        case gameClick
    }
    
    func playSound(sound : SoundOptions){
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".wav") else { return }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("Error playing sound.\(error.localizedDescription)")
        }
    }
}
struct GameView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject private var mainAlgorithm = GameMainAlgorithm()
    
    var body: some View {
        GeometryReader{ geometry in
            Image("Image 2")
                .scaledToFill()
       .edgesIgnoringSafeArea(.all)

            VStack{
                Spacer()
                Text("Drop attack")
                    
                    .underline()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .fontDesign(.rounded)
                    .bold()
                Button{
                    SoundManager.instance.playSound(sound: .Click)
                    mode.wrappedValue.dismiss()
                }label: {
                    GameButton(title: "Quit", background: Color(.systemOrange))
                }
                Spacer()
                    .padding(.leading)
                LazyVGrid(columns:mainAlgorithm.columns,spacing: 5){
                    ForEach(0..<9){ i in
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.black).opacity(0.7)
                                .frame(width: geometry.size.width/3-15,
                                       height:geometry.size.height/3-15)
                            Image(systemName: mainAlgorithm.moves[i]?.indicator ?? "")
                                .resizable()
                                .cornerRadius(2.5)
                                .foregroundColor(.orange)
                                .frame(width: 40, height: 40)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all, -4.0/*@END_MENU_TOKEN@*/)
                        .frame(width: 23.0, height: 116.0)
                        .onTapGesture {
                            SoundManager.instance.playSound(sound: .gameClick)
                            mainAlgorithm.AnalyzeGamerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(mainAlgorithm.isGameboardDisabled)
            .padding(.all)
            .alert(item: $mainAlgorithm.attetionsItem, content: { attetionsItem in
                Alert(title: attetionsItem.title,
                      dismissButton: .default(attetionsItem.buttonTitle,action:{
                    SoundManager.instance.playSound(sound: .attentionSounds)
                    mainAlgorithm.resetGame() }))
            })
        }
    }
    
}

enum Gamer{
    case person, bot
}

struct Move{
    let gamer: Gamer
    let boardValue: Int
    var indicator: String{
        return gamer == .person ? "drop.fill" : "xmark"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
