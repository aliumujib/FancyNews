//
//  ViewController.swift
//  Example
//
//  Created by John DeLong on 5/11/16.
//  Copyright © 2016 delong. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    let SEPERATOR = "<p id=\"speakable-summary\">"
    let SEPERATOR2 = "</div>\n\n<div id=\"social-after-wrapper\""
    
    var newsItem : NewsItem? {
        didSet{
            self.navigationController?.title = newsItem?.title
            let url = URL(string: (newsItem?.urlToImage!)!)
            let color = UIColor(white: 1, alpha: 1)
            let attributtedText = NSMutableAttributedString(string: (newsItem?.title)!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
            
            postTitle.attributedText = attributtedText
            backGroundImageView.kf.setImage(with: url)
            
            if let _ = newsItem?.content{
                //MEH

            }else{
                print("STARTED")
                let articleURL = URL(string: (newsItem?.url)!)
                retrieveArticleText(url: articleURL!) { (stringHTML) in
                    let scrappedData = stringHTML.components(separatedBy: self.SEPERATOR)
                    print("DONE")
                    if scrappedData.count > 1{
                        let scrappedData2 = scrappedData[1].components(separatedBy: self.SEPERATOR2)
                        self.newsItem?.content = self.cleanHTML(string: scrappedData2[0])
                        self.collectionView.collectionViewLayout.invalidateLayout()
                        self.collectionView.reloadData()
                    }
                }
            }

        }
    }
    
    func cleanHTML(string: String) -> String {
        let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    func retrieveArticleText(url: URL, data: @escaping (String) -> ())  {
        Alamofire.request(url).responseString { (string) in
            data(string.value!)
        }
        
    }
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout ()
        layout.scrollDirection  = .vertical
        layout.minimumLineSpacing = 0
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        cv.showsVerticalScrollIndicator = false
        cv.clipsToBounds = true
        cv.isPagingEnabled = true
        return cv
    }()

    
    
    let postTitle : UITextView = {
        let postTitle = UITextView()
        postTitle.isEditable = false
        postTitle.backgroundColor = .clear
        return postTitle
    }()
    
    var backGroundImageView: UIImageView = {
        let bg = UIImageView()
        bg.image = UIImage(named: "shovel")
        bg.contentMode = .scaleAspectFill
        bg.clipsToBounds = true
        return bg
    }()
    
    
    private var headerHeightContraint: NSLayoutConstraint!
    var screenheight : CGFloat!
    var screenwidth : CGFloat!
    
    var minHeight: CGFloat = 70.0
    var maxHeight: CGFloat = 0.0
    
    var previousScrollOffset : CGFloat = 0.0
    var headerHeightConstant: CGFloat!
    
    var detailCellID = "detailCellID"
    var headerCellID = "headerCellID"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        self.view.addSubview(backGroundImageView)
        backGroundImageView.addSubview(postTitle)
        screenheight = self.view.frame.size.height
        screenwidth = self.view.frame.size.width
        maxHeight = screenheight / 3
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        if let barBtnItem = self.navigationController?.navigationBar.topItem{
            barBtnItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
       _ = backGroundImageView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0 , leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: screenheight/3)
        
        _ =  postTitle.anchor(backGroundImageView.topAnchor, left: backGroundImageView.leftAnchor, bottom: nil, right: backGroundImageView.rightAnchor, topConstant: 100 , leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 100)
            
            print("FIRST HEADER HEIGHT \(maxHeight)")
            self.headerHeightConstant = self.maxHeight

    
        // Do any additional setup after loading the view.
        
       _ = collectionView.anchor(backGroundImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        collectionView.register(ArticleContentCell.self, forCellWithReuseIdentifier: detailCellID)
        
        
        _ = (self.navigationController?.navigationBar.frame.origin.y)! + 10
        }
    }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
            let absoluteTop: CGFloat = 0;
            let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
            
            let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
            let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
            //
            // Will implement header height logic here next
            //
            self.previousScrollOffset = scrollView.contentOffset.y
            
            var newHeight = self.headerHeightConstant
            
            if isScrollingDown {
                newHeight = max(self.minHeight, self.headerHeightConstant - abs(scrollDiff))
            } else if isScrollingUp {
                   newHeight = min(self.maxHeight, self.headerHeightConstant + abs(scrollDiff))
            }
            
            if newHeight != self.headerHeightConstant {
                self.headerHeightConstant = newHeight
            }
            
            
            let range = self.maxHeight - self.minHeight
            let openAmount = self.headerHeightConstant - self.minHeight
            
            if(!openAmount.isLess(than: minHeight)){
                 backGroundImageView.frame = CGRect(x: backGroundImageView.frame.origin.x, y: backGroundImageView.frame.origin.y, width: screenwidth, height: openAmount)
            }
       
            
            collectionView.frame = CGRect(x: 0, y: backGroundImageView.frame.origin.y + backGroundImageView.frame.size.height, width: screenwidth, height: screenheight - backGroundImageView.frame.size.height)
            
            let percentage = openAmount / range
            
            
            fadeViews(views: [postTitle], fadepercent: percentage)
        }
        
        func fadeViews(views: [UIView], fadepercent: CGFloat) {
            for view in views{
                view.alpha = fadepercent
            }
        }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellID, for: indexPath) as! ArticleContentCell
        
        cell.newsItem = self.newsItem
        
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let content = newsItem?.content{
            let approFrame = CGSize(width: screenwidth, height: 1000)
            let textattributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
            
            let estimatedFrame = NSString(string: content).boundingRect(with: approFrame, options: .usesLineFragmentOrigin, attributes: textattributes, context: nil)
            
            return CGSize(width: screenwidth, height: estimatedFrame.height + 50)
        }
        
        return CGSize(width: screenwidth, height:  screenheight)
    }
    
    
    class ArticleContentCell: UICollectionViewCell {
        
        var newsItem: NewsItem? {
            didSet{
                print("SET")
                initPosterDetails(name: (newsItem?.author)!, genre: "Sci-Fi", date: (newsItem?.publishedAt)!)
                self.postText.text = newsItem?.content
            }
        }
        
        
        func initPosterDetails(name: String, genre: String, date: String) {
            let color = UIColor(white: 0.2, alpha: 1)
            
            let attributtedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
            
            attributtedText.append(NSAttributedString(string: " in \(genre)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: color]))
            
            attributtedText.append(NSAttributedString(string: "\n\(date)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin), NSForegroundColorAttributeName: color]))
            
            
            posterDetails.attributedText = attributtedText
        }
        
        
        let posterView : UIView = {
            let cardView = UIView()
            return cardView
        }()
        
        let articleContentView : UIView = {
            let cardView = UIView()
            return cardView
        }()
        
        
        let posterImage : UIImageView = {
            let posterImg = UIImageView()
            posterImg.image = UIImage(named: "shovel")
            posterImg.contentMode = .scaleAspectFit
            posterImg.layer.cornerRadius = 3.0
            return posterImg
        }()
        
        let posterDetails : UITextView = {
            let posrdetails = UITextView()
            posrdetails.isEditable = false
            posrdetails.layer.cornerRadius = 3.0
            return posrdetails
        }()
        
        
        let postText : UITextView = {
            let postText = UITextView()
            postText.isEditable = false
            postText.isScrollEnabled = false
            postText.layer.cornerRadius = 3.0
            return postText
        }()
        
       
        let divider : UIView = {
            let div = UIView()
            div.backgroundColor = .gray
            return div
        }()
        
        
        override func layoutSubviews() {
            setUpViews()
        }
        
        
        func setUpViews() {
            
            addSubview(posterView)
            addSubview(divider)
            addSubview(articleContentView)
            
            
            posterView.addSubview(posterImage)
            posterView.addSubview(posterDetails)
            
            
            articleContentView.addSubview(postText)
            
            
            posterView.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            
            posterView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            divider.anchorWithConstantsToTop(posterView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            
            articleContentView.anchorToTop(divider.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
            
            
            postText.anchorWithConstantsToTop(articleContentView.topAnchor, left: articleContentView.leftAnchor, bottom: articleContentView.bottomAnchor, right: articleContentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
            
            
           
            setupPosterCardSubViews()
            
        }
        
        
        func setupPosterCardSubViews() {
            _  = posterImage.anchorWithConstantsToTop(posterView.topAnchor, left: posterView.leftAnchor, bottom: posterView.bottomAnchor, right: posterView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 5)
            
            _  = posterDetails.anchorWithConstantsToTop(posterView.topAnchor, left: posterImage.rightAnchor, bottom: posterView.bottomAnchor, right: posterView.rightAnchor, topConstant: 10, leftConstant: 5, bottomConstant: 10, rightConstant: 10)
        
            
            posterImage.widthAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 0.18).isActive = true
        }
        
        
    }
    
}
