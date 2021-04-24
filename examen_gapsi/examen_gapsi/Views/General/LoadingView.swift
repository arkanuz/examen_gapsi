//
//  LoadingView.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import UIKit

// View mientras se carga información
class LoadingView: UIView {
    
    var contentView : UIView!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
    }
    
    func commonInit() {
        let screenSize = UIScreen.main.bounds
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.backgroundColor = UIColor.clear
        
        let width = CGFloat(200)
        let height = CGFloat(150)
        
        contentView = UIView()
        contentView.frame = CGRect(x: (self.frame.size.width - width)/2, y: (self.frame.size.height - height)/2, width: width, height: height)
        contentView.backgroundColor = UIColor.init(white: 0, alpha: 0)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.frame = CGRect(x: contentView.frame.size.width/2 - 22, y: contentView.frame.size.height/2 - 44, width: 44, height: 44)
        contentView.addSubview(spinner)
        spinner.startAnimating()
        
        let downloadLabel = UILabel()
        downloadLabel.frame = CGRect(x: 0, y: spinner.frame.origin.y + spinner.frame.size.height, width: contentView.frame.size.width, height: 44)
        downloadLabel.text = "Cargando..."
        downloadLabel.textColor = UIColor.white
        downloadLabel.textAlignment = .center
        contentView.addSubview(downloadLabel)
        
        self.addSubview(contentView)
        
        self.isHidden = true
    }
    
    func showLoadingView() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        }
    }
    
    func hideLoadingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
        }) { (Bool) in
            self.isHidden = true
        }
    }
}
