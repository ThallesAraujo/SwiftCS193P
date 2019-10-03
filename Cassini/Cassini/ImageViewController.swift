//
//  ImageViewController.swift
//  Cassini
//
//  Created by Thalles Araújo on 30/09/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            
            
            //Checa se já existe uma tela sendo apresentada
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get{
            return imageView.image
        }set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
            //spinner.stopAnimating()
            //Caso houvesse um spinner, esse seria o melhor lugar para este código,
            //pois não se desejaria que o spinner parasse caso o usuário voltasse uma tela
            //e uma nova imagem fosse requisitada (multithreading)
        }
    }

    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            //Habilitar zoom P1
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    var imageView = UIImageView()
    
    
    private func fetchImage(){
        if let url = imageURL{
            //Multithreading
            //Spinner -> ActivityIndicator
            //Iniciar spinning -> spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
                let urlContents = try? Data(contentsOf: url)
                //código de interface deve ser feito na thread main
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL{
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil{
            imageURL = DemoURLs.placebo
        }
    }
    
    //Habilitar zoom P2
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
        }
        
    }

}

//no prepare(forSegue), é possível utilizar:
// var destination = segue.destination
// if let navcon = destination as? UINavigationController{
//      destination = navcon.visibleViewController ?? navcon
//}
//...para desemcapsular o ViewController embutido em um NavigationController
//Esse código funciona mesmo quando não se tem um NavigationController

//ou, pode-se criar uma extensão:

extension UIViewController{
    var contents: UIViewController{
        //Uma extensão desse gênero também pode ser aproveitada para resgatar
        //a guia atual num TabViewController, por exemplo
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        }else{
            return self
        }
    }
}
