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
    
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceOldLabel: UILabel!
    @IBOutlet weak var priceSaleLabel: UILabel!
    var productID: String = ""
    var quantity: Int = 0
    var completionBlock: Block?
    var productDetail: ProductsForRealm? = nil
    var xForWeight: Int = 0
    
    @IBAction func addProduct(sender: AnyObject) {
        quantity += 1
        xForWeight = Int((productDetail?.weightAdd) ?? "") ?? 0
        xForWeight += Int((productDetail?.weight) ?? "") ?? 0
        //updateProduct()
        completionBlock?()
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        guard quantity > 1 || (Int((productDetail?.weightAdd) ?? "") ?? 0 > Int((productDetail?.weight) ?? "") ?? 0) else { return }
        quantity -= 1
        xForWeight = (Int((productDetail?.weightAdd) ?? "") ?? 0)
        xForWeight -= (Int((productDetail?.weight)!)!)
        //updateProduct()
        completionBlock?()
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
