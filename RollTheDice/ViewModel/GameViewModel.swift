//
//  GameViewModel.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//

import SwiftUI

let zeros = Array(repeating: "0", count: 6)
let ones = Array(repeating: "1", count: 6)

@Observable
class GameViewModel {
    
    private (set) var playerIndex = 0
    private (set) var values = [String]()
    
    private var model: GameModel
    
    init(
        players: [String],
        faces: [String],
        combos: [String],
        forfeits: [String]
    ) {
        self.model = GameViewModel.createGame(players: players)
        self.values = faces + zeros + combos + zeros + forfeits + ones
        
    }
    
    private static func createGame(players:[String]) -> GameModel
    {
        return GameModel(playerNames: players)
    }
    
    /**
     This computed property checks if the game is over.
     - Returns: A `Bool` indicating whether the game is over. Returns `true` if all players have filled all their scores, and `false` otherwise.
     */
    public var isGameOver: Bool {
        return model.players.allSatisfy { $0.hasFilledAllScores() }
    }
    
    public var currentPlayer : Player {
        return model.players[playerIndex]
    }
    
    public func nextPlayer()
    {
        playerIndex = (playerIndex + 1) % model.players.count
    }
    
    private func scoreTypeForIndex(_ index: Int) -> ScoreType?
    {
        let halfCases = ScoreType.allCases.count / 2
        
        switch index {
        case halfCases...(halfCases * 2 - 1):
            return ScoreType.allCases[index - halfCases]
        case (halfCases * 3)...(halfCases * 4 - 1):
            return ScoreType.allCases[index - halfCases * 2]
        default:
            // Other indices do not correspond to scores
            return nil
        }
    }
    
    func canChoose(_ index: Int) -> Bool {
        let scoreType = scoreTypeForIndex(index)
        
        guard let type = scoreType else {
            return false
        }
        
        return currentPlayer.canChoose(scoreType: type)
    }
    
    func choose(_ index: Int) {
        if canChoose(index){
            if let scoreType = scoreTypeForIndex(index) {
                if let score = Int(values[index]) {
                    try? model.players[playerIndex].chooseScore(for: scoreType, score: score)
                }
            }
        }
    }
    
    func updatePossibleScores(dice: [Int], playerIndex: Int) {
        
        guard (0..<model.players.count).contains(playerIndex) else {
            print("Player Index \(playerIndex) out of range. Must be between 0 and \(model.players.count - 1) inclusive")
            return
        }
        
        let allPossibleScores = GameModel.calculateScores(dice: dice)
        let possibleScoresForPlayer = currentPlayer.possibleScores(from: allPossibleScores)
        
        // update the values array from possibleScoresForPlayer
        // Update the values array from possibleScoresForPlayer
        for (scoreType, score) in possibleScoresForPlayer {
            let baseIndex = scoreType.index
            let offsetIndex: Int
            switch scoreType {
            case .ones, .twos, .threes, .fours, .fives, .sixes:
                offsetIndex = baseIndex + 6 // Offset for faces
            case .threeOfAKind, .fourOfAKind, .fullHouse, .smallStraight, .largeStraight, .yeeha:
                offsetIndex = baseIndex + 12 // Offset for combos
            }
            values[offsetIndex] = "\(score)"
        }
    }
}

