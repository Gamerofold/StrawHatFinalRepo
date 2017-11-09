//
//  BuyerDetailVController.swift
//  Project3
//
//  Created by Shane Bersiek on 11/6/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit

class BuyerDetailVController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:Properties
    
    var itemImgArray = [UIImage]()
    
    @IBOutlet weak var ImageScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollViewImages()
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviews", for: indexPath)
        
        return cell
    }
    
    
    func setScrollViewImages(){
        itemImgArray = [#imageLiteral(resourceName: "megaManBox"), #imageLiteral(resourceName: "megaman"), #imageLiteral(resourceName: "megaManBoss")]
        
        for i in 0..<itemImgArray.count {
            
            let imageView = UIImageView()
            imageView.image =  itemImgArray[i]
            let xposition = self.view.frame.width * (CGFloat(i) * 0.92)
            imageView.frame = CGRect(x: xposition, y: 0, width: self.ImageScrollView.frame.width, height: self.ImageScrollView.frame.height)
            ImageScrollView.contentSize.width = ImageScrollView.frame.width * (CGFloat(i) + 1.85
            )
            ImageScrollView.addSubview(imageView)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue pressed")
        
    }
    
    
}
