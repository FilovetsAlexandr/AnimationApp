//
//  ViewController.swift
//  AnimationApp
//
//  Created by Alexandr Filovets on 4.10.23.
//

import UIKit

class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var startScrollAnimationBtn: UIButton!
    @IBOutlet var switchUI: UISwitch!
    @IBOutlet var startAnimationBtn: UIButton!
    
    var isScrolling = false
    var currentIndex = 0
    var timer: Timer?
    
    let images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.isUserInteractionEnabled = false
        switchUI.addTarget(self, action: #selector(switсhAction(_:)), for: .valueChanged)
        switchUI.isOn = false
        
        startAnimationBtn.isEnabled = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func switсhAction(_ sender: UISwitch) {
        collectionView.isUserInteractionEnabled = sender.isOn
        collectionView.reloadData()
        startScrollAnimationBtn.isEnabled = !sender.isOn
        startScrollAnimationBtn.isEnabled = switchUI.isOn ? false : true
    }
    
    @IBAction func startScrollAnimation(_ sender: Any) { startScrollingAnimation() }
    
    func startScrollingAnimation() {
        isScrolling = true
        startAnimationBtn.isEnabled = false

        currentIndex = 0
           
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
           
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScrollingAnimation()
        }
    }

    @objc func scrollToNextItem() {
        currentIndex += 1
        let nextIndex = currentIndex % images.count
        let nextIndexPath = IndexPath(item: nextIndex, section: 0)
        
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func stopScrollingAnimation() {
        startAnimationBtn.isEnabled = true

        isScrolling = false
        timer?.invalidate()
        timer = nil
            
        let randomIndex = Int.random(in: 0 ..< images.count)
        let randomIndexPath = IndexPath(item: randomIndex, section: 0)
            
        collectionView.scrollToItem(at: randomIndexPath, at: .centeredHorizontally, animated: true)
    }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { images.count }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        let image = images[indexPath.item]
        cell.imageView.image = image

        return cell
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { collectionView.bounds.size }
}
