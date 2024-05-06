//
//  GameModel.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//

import Foundation

struct GameModel {
    
    var players = [Player]()

    init(playerNames: [String]) {
        for name in playerNames {
            let player = Player(name: name)
            players.append(player)
        }
    }
    
    static func initScores() -> [ScoreType: Int] {
        var scores = [ScoreType: Int]()
        for scoreType in ScoreType.allCases {
            scores[scoreType] = 0
        }
        return scores
    }
    
    static func calculateScores(dice: [Int]) -> [ScoreType: Int] {
        var scores = GameModel.initScores()
        let sortedDice = dice.sorted()
        let diceSet = Set(sortedDice)
        
        // Calculate the score for each category
        scores[.ones] = sortedDice.filter { $0 == 1 }.reduce(0, +)
        scores[.twos] = sortedDice.filter { $0 == 2 }.reduce(0, +)
        scores[.threes] = sortedDice.filter { $0 == 3 }.reduce(0, +)
        scores[.fours] = sortedDice.filter { $0 == 4 }.reduce(0, +)
        scores[.fives] = sortedDice.filter { $0 == 5 }.reduce(0, +)
        scores[.sixes] = sortedDice.filter { $0 == 6 }.reduce(0, +)
        
        let threeOfAKind = sortedDice.filter { dice in sortedDice.filter { $0 == dice }.count >= 3 }.reduce(0, +)
        scores[.threeOfAKind] = threeOfAKind
        
        let fourOfAKind = sortedDice.filter { dice in sortedDice.filter { $0 == dice }.count >= 4 }.reduce(0, +)
        scores[.fourOfAKind] = fourOfAKind
        
        let fullHouse = (threeOfAKind > 0 && sortedDice.filter { dice in sortedDice.filter { $0 == dice }.count == 2 }.count == 2) ? 25 : 0
        scores[.fullHouse] = fullHouse
        
        let smallStraight = (diceSet.count >= 4 && (diceSet.contains(1) && diceSet.contains(2) && diceSet.contains(3) && diceSet.contains(4)) ||
            (diceSet.contains(2) && diceSet.contains(3) && diceSet.contains(4) && diceSet.contains(5)) ||
            (diceSet.contains(3) && diceSet.contains(4) && diceSet.contains(5) && diceSet.contains(6))) ? 30 : 0
        scores[.smallStraight] = smallStraight
        
        let largeStraight = (diceSet.count == 5 && (diceSet.contains(1) && diceSet.contains(2) && diceSet.contains(3) && diceSet.contains(4) && diceSet.contains(5) ||
            diceSet.contains(2) && diceSet.contains(3) && diceSet.contains(4) && diceSet.contains(5) && diceSet.contains(6))) ? 40 : 0
        scores[.largeStraight] = largeStraight

        let yeeha = (diceSet.count == 1) ? 50 : 0
        scores[.yeeha] = yeeha
        return scores
    }
}

