//
//  ViewController.swift
//  PlayingCard
//
//  Created by Thalles Araújo on 26/09/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    //Adicionar reconhecimento de gesto de swipe na view
    //Adicionado via outlet no InterfaceBuilder
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
        }
    }
    
    @objc func nextCard(){
        if let card = deck.draw(){
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended: playingCardView.isFacedUp = !playingCardView.isFacedUp
        default: break
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

