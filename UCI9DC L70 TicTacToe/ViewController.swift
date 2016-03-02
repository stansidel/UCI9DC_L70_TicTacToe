//
//  ViewController.swift
//  UCI9DC L70 TicTacToe
//
//  Created by Stanislav Sidelnikov on 29/02/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TicTacToeGameDelegate {
    @IBOutlet var crossNoughtsButtons: [UIButton]!
    @IBOutlet weak var gameBoardImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    private var game: TicTacToeGame?
    @IBOutlet weak var labelsCentralConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewGame()
        positionLabelsWithAnimation(0)
    }

    func startNewGame() {
        game = TicTacToeGame()
        game?.delegate = self
        for button in crossNoughtsButtons {
            button.alpha = 0
        }
    }

    private func positionLabels() {
        if game?.activeGame == true {
            labelsCentralConstraint.constant = -1 * (view.frame.width / 2 + resultLabel.frame.width / 2 + 10)
        } else {
            labelsCentralConstraint.constant = 0
        }
    }

    private func positionLabelsWithAnimation(duration: NSTimeInterval) {
        positionLabels()
        // When the game is finished we want to first display the elements and then move them in
        if game?.activeGame != true {
            self.resultLabel.alpha = 1.0
            self.playAgainButton.alpha = 1.0
        }
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(duration, animations: { self.view.layoutIfNeeded() }) { (completed) -> Void in
            if completed && self.game?.activeGame == true {
                // When the game is started we want to move the elements out first and only then hide them.
                // Hiding is needed so that they are not visible during rotation
                self.resultLabel.alpha = 0.0
                self.playAgainButton.alpha = 0.0
            }
        }

    }

    override func viewWillLayoutSubviews() {
        labelsCentralConstraint.constant = labelsCentralConstraint.constant * 3
    }

    override func viewDidLayoutSubviews() {
        positionLabels()
    }

    @IBAction func gameBoardTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let location = sender.locationInView(gameBoardImageView)
            let thirdX = Int(gameBoardImageView.frame.width / 3)
            let thirdY = Int(gameBoardImageView.frame.height / 3)
            var index = 0
            index += Int(Int(location.y) / thirdY) * 3
            index += Int(Int(location.x) / thirdX)
            do {
                try game?.fieldChosen(index)
            } catch let err {
                print("Error when trying field with index \(index). Error: \(err).")
            }
        }
    }

    @IBAction func playAgain(sender: AnyObject) {
        startNewGame()
        positionLabelsWithAnimation(0.3)
    }

    // MARK: - TicTacToeGameDelegate

    func fieldUpdated(index: Int, player: TicTacToeGamePlayer) {
        guard let button = crossNoughtsButtons.filter({ $0.tag == index }).first else {
            return
        }
        let imageName = player == .Noughts ? "nought.png" : "cross.png"
        button.setImage(UIImage(named: imageName), forState: .Normal)
        UIView.animateWithDuration(0.5) { () -> Void in
            button.alpha = 1.0
        }

    }

    func gameFinished(result: TicTacToeGameResult) {
        switch result {
        case .Draw:
            resultLabel.text = NSLocalizedString("It's a draw", comment: "Central label text for the draw")
        case let .Win(player):
            var playerString = ""
            if player == .Noughts {
                playerString = NSLocalizedString("Noughts", comment: "Player name for noughts")
            } else {
                playerString = NSLocalizedString("Crosses", comment: "Player name for crosses")
            }
            resultLabel.text = NSLocalizedString(String(format:"%@ have won!", playerString), comment: "Central label text for the win")
        }
        positionLabelsWithAnimation(1.0)
    }

}

