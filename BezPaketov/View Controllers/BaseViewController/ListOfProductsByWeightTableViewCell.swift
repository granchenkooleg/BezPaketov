//
//  ListOfProductsByWeightTableViewCell.swift
//  Bezpaketov
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit


class ListOfProductsByWeightTableViewCell: UITableViewCell {
    
    @IBOutlet var buttonCart: UIButton!
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    @IBAction func buttonPressedCart(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
        
    }
    
    @IBAction func buttonPressedCartForListVCOfWeight(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    // For +
    @IBOutlet weak var addProductButton: UIButton!
    var buttomAddAction: ((_ sender: AnyObject) -> Void)?
    
    // For -
    @IBOutlet weak var subProductButton: UIButton!
    var buttonSubAction: ((_ sender: AnyObject) -> Void)?
  
    
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceOldLabel: UILabel!
    @IBOutlet weak var priceSaleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var quantity: Int = 0
    var completionBlock: Block?
    var productDetail: Product? = nil
    var valueWeightForButton: Int = 0
    var xForWeight: Int = 0
    
    @IBAction func addProduct(sender: AnyObject) {
        self.buttomAddAction?(sender as AnyObject)
//        quantity += 9
//        xForWeight += valueWeightForButton
//        //updateProduct()
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        self.buttonSubAction?(sender as AnyObject)
//        guard quantity > 1 || (Int((productDetail?.weightAdd) )  > Int((productDetail?.weight))) else { return }
//        quantity -= 1
//        xForWeight = (Int((productDetail?.weightAdd) ?? "") ?? 0)
//        xForWeight -= (Int((productDetail?.weight) ?? "") ?? 0)
        //updateProduct()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
