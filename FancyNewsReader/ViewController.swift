//
//  ViewController.swift
//  FancyNewsReader
//
//  Created by Abdul-Mujib Aliu on 6/18/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReadButtonClickDelegate {

    var newsItems = [NewsItem]()
    var cellID = "cellID"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout ()
        layout.scrollDirection  = .horizontal
        layout.minimumLineSpacing = 0
        
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = nil
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    let backImage : UIImageView = {
        let backImage = UIImageView()
        backImage.backgroundColor = .clear
        backImage.contentMode = .scaleAspectFill
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backImage.addSubview(blurEffectView)
        backImage.image = UIImage(named: "shovel")
        backImage.layer.cornerRadius = 3.0
        return backImage
    }()
    
    
    
    
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
        pc.numberOfPages = self.newsItems.count
        return pc
    }()
    

    let searchCardView : CardView = {
        let searchCardView = CardView()
        searchCardView.backgroundColor = .gray
        searchCardView.layer.opacity = 0.6
        searchCardView.cornerRadius = 15
        return searchCardView
    }()
    
    
    let searchImage : UIImageView = {
        let searchImage = UIImageView()
        searchImage.backgroundColor = .clear
        searchImage.contentMode = .scaleAspectFill
        searchImage.image = UIImage(named: "glass_white")
        searchImage.layer.cornerRadius = 3.0
        return searchImage
    }()
    
    let settingsImage : UIImageView = {
        let settingsImage = UIImageView()
        settingsImage.backgroundColor = .clear
        settingsImage.contentMode = .scaleAspectFill
        settingsImage.image = UIImage(named: "settings_white")
        settingsImage.layer.cornerRadius = 3.0
        return settingsImage
    }()
    
    let searchTF : UITextField = {
        let searchTF = UITextField()
        searchTF.backgroundColor = .clear
        searchTF.placeholder = "Search"
        searchTF.textColor = .white
        searchTF.font = UIFont(name: (searchTF.font?.fontName)!, size: 15)
        searchTF.setValue(UIColor.init(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")

        searchTF.layer.borderColor = nil
        searchTF.layer.cornerRadius = 3.0
        return searchTF
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    
    func fetchAppCategories(completed: @escaping RequestCompleted)  {
        let dataURL: String = NEWS_API_URL
        let url = URL(string: dataURL)
        
        Alamofire.request(url!).responseJSON{
            response in
            
            if let result  = response.result.value as? Dictionary<String, Any>{
                
                if let mainDict = result["articles"] as? [Dictionary<String, Any>]{
                    if !mainDict.isEmpty{
                        for article in mainDict{
                            
                            let newsItem = NewsItem()
                            newsItem.author = article["author"] as! String!
                            newsItem.title = article["title"] as! String!
                            newsItem.descriptionTitle = article["description"] as! String!
                            newsItem.url = article["url"] as! String!
                            newsItem.urlToImage = article["urlToImage"] as! String!
                            newsItem.publishedAt = article["publishedAt"] as! String!

                            self.newsItems.append(newsItem)
                        }
                    }
                }
                completed()
            }

            
        }
    
    }
    
    func readButtonClicked(newsItem: NewsItem) {
        let detailController = DetailViewController()
        detailController.newsItem = newsItem
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NewsItemCell
        
        cell.newsItem = newsItems[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = targetContentOffset.pointee.x / UIScreen.main.bounds.width
        
        if let url = newsItems[Int(pageNumber)].urlToImage{
            let url = URL(string: url)!
            backImage.kf.setImage(with: url)
        }

        pageControl.currentPage = Int(pageNumber)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backImage)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(searchCardView)
        view.addSubview(settingsImage)
        
        searchCardView.addSubview(searchImage)
        searchCardView.addSubview(searchTF)
        
        
        backImage.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        searchCardView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 10, bottomConstant: 20, rightConstant: 0)
        
        
        searchCardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        searchCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055).isActive = true
        
        pageControl.anchorToTop(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        searchImage.anchorWithConstantsToTop(searchCardView.topAnchor, left: searchCardView.leftAnchor, bottom: searchCardView.bottomAnchor, right: searchCardView.rightAnchor, topConstant: 2, leftConstant: 10, bottomConstant: 10, rightConstant: 0)
        
        searchImage.widthAnchor.constraint(equalTo: searchCardView.widthAnchor, multiplier: 0.05).isActive = true
        
        searchImage.heightAnchor.constraint(equalTo: searchCardView.heightAnchor, multiplier: 0.9).isActive = true
        
        
        settingsImage.anchorWithConstantsToTop(searchCardView.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 10, rightConstant: 0)
        
        settingsImage.widthAnchor.constraint(equalTo: searchCardView.widthAnchor, multiplier: 0.15).isActive = true
        
        settingsImage.heightAnchor.constraint(equalTo: searchCardView.heightAnchor, multiplier: 0.9).isActive = true

        
        
        searchTF.anchorWithConstantsToTop(searchCardView.topAnchor, left: searchImage.rightAnchor, bottom: searchCardView.bottomAnchor, right: searchCardView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
        
        collectionView.register(NewsItemCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchAppCategories { 
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.newsItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

