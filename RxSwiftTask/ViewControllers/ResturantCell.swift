import UIKit

import RxSwift
import RxCocoa


/**
 The cell which displays a Resturant.
 */

class ResturantCell: UITableViewCell {    
    private let disposeBag = DisposeBag()

    /** Used to display the campaign's title. */
    @IBOutlet private(set) weak var nameLabel: UILabel!

    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var offerLabel: UILabel!

    /** The image view which is used to display the campaign's mood image. */
    @IBOutlet private(set) weak var resturantImageView: UIImageView!
    
    @IBOutlet private(set) weak var ratingView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code        
        self.resturantImageView.customziedRoundCorner(radius: 15.0)
        
        assert(nameLabel != nil)
        assert(descriptionLabel != nil)
        assert(offerLabel != nil)
        assert(resturantImageView != nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /** The campaign's name. */
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
        }
    }
    
    var offerText: String? {
        didSet {
            offerLabel?.text = offerText
        }
    }

}
