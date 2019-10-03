//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Thalles Araújo on 01/10/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate {

    @IBOutlet weak var dropZone: UIView! {
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    //método a implementar nas textfields para liberar o teclado ao
    //pressionar return (a comunicação com o teclado é feita pela própria textField)
    //textFieldShouldReturn -> textField.resignFirstResponder()
    
    //textfields tambvém precisam de um delegate. Em geral, seta-se o próprio
    //ViewController e implementa-se UITextFieldDelegate
    
    //o contrário é feito com textField.becomeFirstResponder()
    

    
    //Determina se pode ou não receber o drop (no caso, só se aceita objetos do tipo URL ou UIImage)
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    //O que será feito com os itens retornados do drop?
    //Geralmente, se utiliza .copy
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher!
    
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
            }
        }
        
        session.loadObjects(ofClass: NSURL.self, completion: {nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        })
        
        session.loadObjects(ofClass: UIImage.self, completion: {images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        })
    }
    
    
    //operações assíncronas em uma collection view para evitar desconexão
    //com o modelo
    //collectionView.performBatchUpdates(closure, completion)
    
    @IBOutlet weak var emojiArtView: EmojiArtView!

    
}

