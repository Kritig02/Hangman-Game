//
//  HGLabels.swift
//  HangmanGame
//
//  Created by Kriti on 2024-02-04.
//

import UIKit

class HGLabels: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, backgroundColor: UIColor){
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.text = text
        configure()
        
    }
    
    init(text: String, backgroundColor: UIColor, fontSize: CGFloat){
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        configure()
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        //font = UIFont.systemFont(ofSize: 24)
        textAlignment = .center
        textColor = .systemPurple
        numberOfLines = 0
    }
}
