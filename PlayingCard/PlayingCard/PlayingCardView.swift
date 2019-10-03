//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Thalles Araújo on 26/09/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import UIKit

//Anotação para indicar que a view é renderizável no InterfaceBuilder

@IBDesignable
class PlayingCardView: UIView {
    
    //Possibilita setar os valores da variável no InterfaceBuilder
    @IBInspectable
    var rank: Int = 5 {
        didSet {
            redraw()
        }
    }
    
    @IBInspectable
    var suit: String = "♥️"{
        didSet {
            redraw()
        }
    }
    
    @IBInspectable
    var isFacedUp = true{
        didSet {
            redraw()
        }
    }

    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func configureCornerLabel(_ label:UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFacedUp
    }
    
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        //Utilizar o número de linhas que seja necessário
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    //convenience init -> Métodos construtores auxiliares (ou de conveniência,como o nome diz)
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        redraw()
        
        //Exemplo de animação de virar
        /*UIView.transition(
            with: choosenCardView,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {chosenCardView.isFacedUp = !chosenCardView.isFacedUp})*/
        //Em animations ou em completion, é possível encadear várias animações
    }
    
    private func redraw(){
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    //organizar as subviews. Chamado em setNeedsLayout()
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        
        //girar a label de cabeça para baixo. Mas levando a label de volta para baixo, pois somente girar fará o cartão
        //rotacionar em seu próprio eixo, deixando a label fora de foco
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
    
    //Tratar o pinch to zoom
    /*@objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state{
        case .changed, .ended:
            //sendo faceCardScale uma var com didSet ao invés de uma constante
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }*/
    //depois disso, chamar no view controller do mesmo jeito que o swipeGesture
    
    //redesenhar a tela. Chamado em setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        
        /*if let context = UIGraphicsGetCurrentContext(){
            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            context.setLineWidth(5.0)
            UIColor.green.setFill()
            UIColor.red.setStroke()
            context.strokePath()
            context.fillPath()
        }
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        path.fill()*/
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //addClip() -> conteúdo adicionado depois será adicionado neste retângulo
        roundedRect.addClip()
        
        UIColor.white.setFill()
        roundedRect.fill()
        
        //renderizar o verso da carta
        //argumentos depois do named são necessários para a renderização no InterfaceBuilder
        if !isFacedUp, let cardBackImage = UIImage(named: "cardBack", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
            cardBackImage.draw(in: bounds)
        }
        
        //renderizar imagens no xcassets:
        /*if let faceCardImage = UIImage(named: rankString+suit){
            faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        }*/
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private func centeredAttributedString (_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }

}

//EXTENSIONS--------------------------------------------------------------------------------------------------------------

extension PlayingCardView{
    
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
    
}

extension CGRect{
    var leftHalf: CGRect{
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var highHalf: CGRect{
         return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGRect) -> CGRect{
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect{
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
    
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
