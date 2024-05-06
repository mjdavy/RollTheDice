//
//  PlayerModel.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//

import Foundation

enum PlayerError: Error {
    case invalidScoreType
}

enum ScoreType: CaseIterable {
    case ones
    case twos
    case threes
    case fours
    case fives
    case sixes
    case threeOfAKind
    case fourOfAKind
    case fullHouse
    case smallStraight
    case largeStraight
    case yeeha
    
    var index: Int {
        return ScoreType.allCases.firstIndex(of: self)!
    }
}

struct Player {
    var name: String
    var scores: [ScoreType:Int?]
    var isCurrentPlayer: Bool
    var isWinner: Bool
    
    init(name: String, isCurrentPlayer: Bool = false, isWinner: Bool = false) {
        self.name = name
        self.isCurrentPlayer = isCurrentPlayer
        self.isWinner = isWinner
        self.scores = Dictionary(uniqueKeysWithValues: ScoreType.allCases.map { ($0, nil) })
    }
    
    var totalScore: Int {
        return scores.values.compactMap { $0 }.reduce(0, +)
    }
    
    func hasScored(for type: ScoreType) -> Bool {
        return scores[type] != nil
    }
    
    /**
     This function returns the possible score types and their corresponding scores that a player can choose for their next turn.
     - Parameter allPossibleScores: A dictionary representing all possible scores based on the dice values the player rolled. The keys are of type `ScoreType` and the values are the corresponding scores of type `Int`.
     - Returns: A dictionary with keys of type `ScoreType` and values of type `Int` representing the score types and their corresponding scores that the player can choose. These are the entries from the `allPossibleScores` dictionary where the corresponding value in the `scores` dictionary is `nil`.
     */
    func possibleScores(from allPossibleScores: [ScoreType: Int]) -> [ScoreType: Int] {
        var possibleScores: [ScoreType: Int] = [:]
        for (key, value) in allPossibleScores {
            if scores.contains(where: { $0.key == key && $0.value == nil }) {
                possibleScores[key] = value
            }
        }
        return possibleScores
    }
    
    /**
     This function checks if the player has filled all possible scores.
     - Returns: A `Bool` indicating whether the player has filled all possible scores. Returns `true` if all values in the `scores` dictionary are non-nil, and `false` otherwise.
     */
    func hasFilledAllScores() -> Bool {
        return scores.values.allSatisfy { $0 != nil }
    }
    
    /**
     This function allows a player to choose a score for a particular score type.
     - Parameter type: The `ScoreType` that the player wants to score for.
     - Parameter score: The score that the player wants to assign to the `ScoreType`.
     - Parameter allPossibleScores: A dictionary representing all possible scores based on the dice values the player rolled. The keys are of type `ScoreType` and the values are the corresponding scores of type `Int`.
     - Throws: `PlayerError.invalidScoreType` if the `ScoreType` is not a possible score.
     */
    mutating func chooseScore(for type: ScoreType, score: Int) throws {
        guard scores.keys.contains(type) else {
            throw PlayerError.invalidScoreType
        }
        scores[type] = score
    }
    
    func canChoose(scoreType: ScoreType) -> Bool {
        return scores.contains(where: { $0.key == scoreType && $0.value == nil})
    }
}

