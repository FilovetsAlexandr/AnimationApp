//
//  ViewController.swift
//  AnimationApp
//
//  Created by Alexandr Filovets on 4.10.23.
//
import Lottie
import UIKit

final class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startScrollAnimationBtn: UIButton!
    @IBOutlet weak var switchUI: UISwitch!
    @IBOutlet weak var startAnimationBtn: UIButton!

    private var isScrolling = false
    private var currentIndex = 0
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }

    @IBAction func lottiButtonAction(_ sender: Any) {
        let selectedAnimationView = AnimationsModels.animationsImages[currentIndex]
        selectedAnimationView.frame = collectionView.bounds
        selectedAnimationView.contentMode = .scaleAspectFit
        collectionView.addSubview(selectedAnimationView)
        selectedAnimationView.play()
    }

    @IBAction func switсhAction(_ sender: UISwitch) {
        collectionView.isUserInteractionEnabled = sender.isOn
        startScrollAnimationBtn.isEnabled = !sender.isOn
        startAnimationBtn.isEnabled = !sender.isOn
        collectionView.reloadData()
    }

    @IBAction func startScrollAnimation(_ sender: Any) { startScrollingAnimation() }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { AnimationsModels.animationsImages.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath)

        // Очистка содержимого ячейки
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let animationView = AnimationsModels.animationsImages[indexPath.item]
        animationView.frame = cell.bounds
        animationView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(animationView)
        cell.tag = indexPath.item

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        let selectedAnimationView = AnimationsModels.animationsImages[currentIndex]
        selectedAnimationView.frame = collectionView.bounds
        selectedAnimationView.contentMode = .scaleAspectFit
        collectionView.addSubview(selectedAnimationView)
        selectedAnimationView.play()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { collectionView.bounds.size }
    
    private func startScrollingAnimation() {
        isScrolling = true
        startAnimationBtn.isEnabled = false

        currentIndex = 0

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScrollingAnimation()
        }
    }

    @objc private func scrollToNextItem() {
        currentIndex += 1
        if currentIndex >= AnimationsModels.animationsImages.count { currentIndex = 0 }
        let nextIndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: false)
    }

    private func stopScrollingAnimation() {
        startAnimationBtn.isEnabled = true
        isScrolling = false
        timer?.invalidate()
        timer = nil

        currentIndex = Int.random(in: 0 ..< AnimationsModels.animationsImages.count)
        let randomIndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: randomIndexPath, at: .centeredHorizontally, animated: true)
    }
    private func setupSettings() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.isUserInteractionEnabled = false
        switchUI.addTarget(self, action: #selector(switсhAction(_:)), for: .valueChanged)
        switchUI.isOn = false

        startAnimationBtn.isEnabled = false

        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
}
