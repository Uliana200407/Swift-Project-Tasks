
import SwiftUI
final class GameMainAlgorithm: ObservableObject{
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled  = false
    @Published var attetionsItem: AttentionsItem?
    
    func AnalyzeGamerMove(for i: Int){
        if isPlaceOccupied(in: moves, forValue: i){return}
        moves[i] = Move(gamer:  .person, boardValue: i)
        
        if checkWinStatus(for: .person, in: moves){
            attetionsItem = AttentionsContext.personWin
            return
        }
        if checkForDraw(in: moves){
            attetionsItem = AttentionsContext.draw
            return
        }
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            SoundManager.instance.playSound(sound: .gameClick)
            let botPosition = self.determineBotMovePosition(in: self.moves)
            self.moves[botPosition] = Move(gamer: .bot, boardValue: botPosition)
            self.isGameboardDisabled = false
            if self.checkWinStatus(for: .bot, in: self.moves){
                self.attetionsItem = AttentionsContext.botWin
                return
            }
            if self.checkForDraw(in: self.moves){
                self.attetionsItem = AttentionsContext.draw
                return
            }
        }
    }
    func isPlaceOccupied(in moves: [Move?],forValue value :Int)-> Bool{
        return moves.contains(where: {$0?.boardValue == value})
    }
        func determineBotMovePosition(in moves:[Move?])->Int{
            
            //AI winner, choosing not random positions, but thinking where to put icon, if the place occupied - block it
            let winPatterns:Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[2,4,6],[0,4,8]]
            let botMoves = moves.compactMap {$0}.filter{$0.gamer == .bot
            } //filtering bot moves
            let botPosition = Set(botMoves.map {$0.boardValue}) //checking win status
            for pattern in winPatterns{
                let winPosition = pattern.subtracting(botPosition)
                if winPosition.count == 1{
                    let isAvailable = !isPlaceOccupied(in: moves,forValue:winPosition.first!)
                    if isAvailable{return winPosition.first!}
                }
            }
            //blocking areas
            let personMoves = moves.compactMap {$0}.filter{$0.gamer == .person
            } //filtering bot moves
            let personPosition = Set(personMoves.map {$0.boardValue}) //checking win status
            for pattern in winPatterns{
                let winPosition = pattern.subtracting(personPosition)
                
                if winPosition.count == 1{
                    let isAvailable = !isPlaceOccupied(in: moves,forValue:winPosition.first!)
                    
                    if isAvailable{return winPosition.first!}
                }
            }
            
            //place in the midle of the field(You can comment, otherwise bot will be unbeatable)
            let middleSquare = 4
            if !isPlaceOccupied(in: moves, forValue: middleSquare){
                return middleSquare
            }

            var movePosition = Int.random(in: 0..<9)
            while isPlaceOccupied(in: moves, forValue: movePosition){
                 movePosition = Int.random(in: 0..<9)}
            return movePosition
    }
    
    func checkWinStatus(for gamer: Gamer, in moves:[Move?])-> Bool{
        let winPatterns:Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[2,4,6],[0,4,8]]
        let gamerMoves = moves.compactMap {$0}.filter{$0.gamer == gamer} //filtering human moves
        let gamerPosition = Set(gamerMoves.map
                                {$0.boardValue}) //checking win status
        for pattern in winPatterns
        where pattern.isSubset(of: gamerPosition){//перевірка на збіг місця та доступних для вийграшу варіагтів - ітерація
            return true}
        return false
    }
    func checkForDraw(in moves: [Move?]) ->Bool{
        return moves.compactMap {$0}.count == 9
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
