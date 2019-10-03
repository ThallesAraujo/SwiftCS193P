//
//  EmojiArtDocumentTableViewController.swift
//  EmojiArt
//
//  Created by Thalles Araújo on 01/10/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import UIKit

class EmojiArtDocumentTableViewController: UITableViewController {
    
    var emojiArtDocuments = ["One", "Two", "Three"]
    
    
    @IBAction func newEmojiArt(_ sender: UIBarButtonItem) {
        emojiArtDocuments += ["Untitled".madeUnique(withRespectTo: emojiArtDocuments)]
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiArtDocuments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        //indexPath.row = índice da linha selecionada
        cell.textLabel?.text = emojiArtDocuments[indexPath.row]
        
        return cell
    }
    
    //setar a parte lateral (documentos) da splitView para ser dispensável
    //deve-se ater ao fato de que as chamadas nesse método podem causar um loop infinito,
    //pois o splitView pode se redesenhar várias vezes na tela.
    //por isso a verificação do modo é necessária
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            emojiArtDocuments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if editingStyle == .insert {
            
        }
    }

}
