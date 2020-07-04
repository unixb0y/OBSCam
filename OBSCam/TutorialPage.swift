//
//  TutorialPage.swift
//  OBSCam
//
//  Created by Davide Toldo on 01.10.20.
//  Copyright © 2020 Davide Toldo. All rights reserved.
//

import UIKit

class TutorialPage: UIViewController {
    let titleText: String
    let descriptionText: String
    let imageName: String
    
    init(title: String, description: String, imageName: String) {
        self.titleText = title
        self.descriptionText = description
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(image: imageName != "" ? UIImage(named: imageName) : nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var descriptionView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = descriptionText
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = imageView.image?.size ?? .zero
        
        view.addSubview(titleView)
        view.addSubview(imageView)
        view.addSubview(descriptionView)
        let constraints = [
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 25),
            
            
            imageView.heightAnchor.constraint(equalToConstant:
                imageSize == .zero ? 0 : (imageSize.height/imageSize.width)*(view.frame.width-50)),
            
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            descriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

