
//  NewsItemViewCell.swift
//  FancyNewsReader
//
//  Created by Abdul-Mujib Aliu on 6/18/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit
import Kingfisher

class NewsItemCell: UICollectionViewCell {
    
    override init(frame: CGRect){
    super.init(frame: frame)
        
        initViews()
        
    }
    
    var delegate : ReadButtonClickDelegate!
    
    var newsItem : NewsItem? {
        didSet{
        
            if let url = newsItem?.urlToImage{
                let url = URL(string: url)!
                imagecardView.kf.setImage(with: url)
            }
            
            initPostDetails(name: (newsItem?.title)!, desc: (newsItem?.descriptionTitle)!)
            
            initPosterDetails(name: (newsItem?.author)!, genre: "Sci-Fi", date: (newsItem?.publishedAt)!)
        
        }
    }
    
    
    let imagecardView : ElevatedImageView = {
        let cardView = ElevatedImageView()
        //cardView.backgroundColor = .yellow
        cardView.cornerRadius = 3.0
        //cardView.image = UIImage(named: "shovel")
        return cardView
    }()
    
    let postercardView : CardView = {
        let cardView = CardView()
        cardView.backgroundColor = .white
        cardView.cornerRadius = 3.0
        return cardView
    }()
    
    let contentcardView : CardView = {
        let cardView = CardView()
        cardView.backgroundColor = .white
        cardView.cornerRadius = 3.0
        return cardView
    }()
    
    
    let posterImage : UIImageView = {
        let posterImg = UIImageView()
        //posterImg.backgroundColor = .red
        posterImg.image = UIImage(named: "shovel")
        posterImg.layer.cornerRadius = 3.0
        return posterImg
    }()
    
    let posterDetails : UITextView = {
        let posrdetails = UITextView()
        //posrdetails.backgroundColor = .blue
        posrdetails.isEditable = false
        posrdetails.layer.cornerRadius = 3.0
        return posrdetails
    }()
    
    
    let postText : UITextView = {
        let postText = UITextView()
        postText.isEditable = false
        //postText.backgroundColor = .orange
        //posrdetails.layer.cornerRadius = 3.0
        return postText
    }()
    
    
    let divider : UIView = {
        let div = UIView()
        div.backgroundColor = .gray
        return div
    }()
    
    

    let readButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Read", for: .normal)
        btn.layer.cornerRadius = 20
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    func readClicked()  {
        print("Read clicked")
        delegate.readButtonClicked(newsItem: newsItem!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews()  {
        
        addSubview(imagecardView)
        addSubview(postercardView)
        addSubview(contentcardView)
        
        postercardView.addSubview(posterImage)
        postercardView.addSubview(posterDetails)

        
        contentcardView.addSubview(postText)
        contentcardView.addSubview(divider)
        contentcardView.addSubview(readButton)
        

      _  =  imagecardView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 90, leftConstant: 15, bottomConstant: 15, rightConstant: 15)
        
        _  =  postercardView.anchor(imagecardView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 15, rightConstant: 15)
        
        _  =  contentcardView.anchor(postercardView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 40, rightConstant: 15)
        
        imagecardView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        
        postercardView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        
        readButton.addTarget(self, action: #selector(readClicked), for: .touchUpInside)
        
        setupPosterCardSubViews()
        
        setupPostContentSubViews()
        
    }
    
    
    func setupPosterCardSubViews() {
        _  = posterImage.anchor(postercardView.topAnchor, left: postercardView.leftAnchor, bottom: postercardView.bottomAnchor, right: postercardView.rightAnchor)
        
        _  = posterDetails.anchorWithConstantsToTop(postercardView.topAnchor, left: posterImage.rightAnchor, bottom: postercardView.bottomAnchor, right: postercardView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        
        
        let genre = "Sci-Fi"
        let date = "21 Aug, 2016"
        let name = "Aliu Abdul-Mujib"
        
        
        initPosterDetails(name: name, genre: genre, date: date)
        
        
        posterImage.widthAnchor.constraint(equalTo: postercardView.widthAnchor, multiplier: 0.18).isActive = true
    }
    
    
    func initPostDetails(name: String, desc: String) {
        let color = UIColor(white: 0.2, alpha: 1)
        
        let attributtedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
        
        attributtedText.append(NSAttributedString(string: "\n\n\(desc)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: color]))
        
        
        postText.attributedText = attributtedText
    }
    
    
    
    func initPosterDetails(name: String, genre: String, date: String) {
        let color = UIColor(white: 0.2, alpha: 1)
        
        let attributtedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
        
        attributtedText.append(NSAttributedString(string: " in \(genre)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: color]))
        
        attributtedText.append(NSAttributedString(string: "\n\(date)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin), NSForegroundColorAttributeName: color]))
        
        
        posterDetails.attributedText = attributtedText
    }
    
    
    func setupPostContentSubViews() {
        _  = postText.anchor(contentcardView.topAnchor, left: contentcardView.leftAnchor, bottom: nil, right: contentcardView.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5)
        
        postText.heightAnchor.constraint(equalTo: contentcardView.heightAnchor, multiplier: 0.75).isActive = true
        
        _  = divider.anchor(postText.bottomAnchor, left: contentcardView.leftAnchor, bottom: nil, right: contentcardView.rightAnchor, topConstant: 10, leftConstant: 5, bottomConstant: 5, rightConstant: 5)
        
         divider.heightAnchor.constraint(equalTo: contentcardView.heightAnchor, multiplier: 0.003).isActive = true

        _  = readButton.anchor(divider.bottomAnchor, left: contentcardView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5)
        
        readButton.heightAnchor.constraint(equalTo: contentcardView.heightAnchor, multiplier: 0.13).isActive = true
        readButton.widthAnchor.constraint(equalTo: contentcardView.widthAnchor, multiplier: 0.27).isActive = true
        
        
            var title = "In wake of Amazon/Whole Foods deal, Instacart has a challenging opportunity"
        
            var description = "Yesterday, Amazon and Whole Foods ruined a perfectly slow news day on a Friday in June with the announcement that Amazon intends to buy Whole Foods for almost.."
        
        initPostDetails(name: title, desc: description)
        
    }
    
    
}
