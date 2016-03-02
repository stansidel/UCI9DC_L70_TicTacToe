//
//  TicTacToeGame.swift
//  UCI9DC L70 TicTacToe
//
//  Created by Stanislav Sidelnikov on 02/03/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//

import Foundation

enum TicTacToeGameError: ErrorType {
    case InvalidFieldIndex
}

enum TicTacToeGameResult {
    case Draw
    case Win(TicTacToeGamePlayer)
}

enum TicTacToeGamePlayer {
    case Noughts
    case Crosses
}

protocol TicTacToeGameDelegate {
    func fieldUpdated(index: Int, player: TicTacToeGamePlayer)
    func gameFinished(result: TicTacToeGameResult)
}

class TicTacToeGame {
    var delegate: TicTacToeGameDelegate?
    private var field = [Int](count: 9, repeatedValue: -1)
    internal private(set) var player = 0
    internal private(set) var activeGame = true

    private func makeTurn() {
        if let result = checkForResult() {
            activeGame = false
            delegate?.gameFinished(result)
        } else {
            player = player == 0 ? 1 : 0
        }
    }

    private func playerByNumber(number: Int) -> TicTacToeGamePlayer {
        return number == 0 ? .Noughts : .Crosses
    }

    func fieldChosen(index: Int) throws -> Bool {
        guard index < field.count else {
            throw TicTacToeGameError.InvalidFieldIndex
        }
        if field[index] == -1 {
            field[index] = player
            delegate?.fieldUpdated(index, player: playerByNumber(player))
            makeTurn()
            return true
        } else {
            return false
        }
    }

    private let winningIndexes = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]

    private func checkForResult() -> TicTacToeGameResult? {
        for indexes in winningIndexes {
            let p = Array(Set(indexes.map({ field[$0] })))
            if p.count != 1 {
                continue
            }
            if p.first! == -1 {
                continue
            }
            return .Win(playerByNumber(p.first!))
        }
        if field.filter({ $0 == -1 }).count == 0 {
            return .Draw
        }
        return nil
    }
}