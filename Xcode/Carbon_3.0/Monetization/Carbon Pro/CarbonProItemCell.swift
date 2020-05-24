//
//  PremiumFeatureTableViewCell.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/16/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class CarbonProItemCell: UITableViewCell {
    
    enum Status {
        case new, updated, comingSoon, none
    }
    
    let style = SelectionStyle.none
    let inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    let newStatusLabelWidth: CGFloat        = 50
    let updatedStatusLabelWidth: CGFloat    = 75
    let comingSoonStatusLabelWidth: CGFloat = 105
    let statusLabelBackgroundColor: UIColor = .clear
    let statusLabelBorderWidth: CGFloat     = 1
    let statusLabelColor: UIColor           = .sapphire
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    ////////////////////
    // MARK: - Lifecycle
    ////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = style
        separatorInset = inset
        configureStatusLabel()
    }
    
    ///////////////////////
    // MARK: - Status Label
    ///////////////////////
    private func configureStatusLabel() {
        setStatus(.none)
        statusLabel.layer.borderWidth = statusLabelBorderWidth
        statusLabel.backgroundColor   = statusLabelBackgroundColor
        statusLabel.textColor         = statusLabelColor
        statusLabel.layer.borderColor = statusLabelColor.cgColor
    }
    
    ////////////////////////////
    // MARK: - Getters & Setters
    ////////////////////////////
    public func setStatus(_ status: Status) {
        switch status {
        case .new:
            statusLabelWidth.constant = newStatusLabelWidth
            statusLabel.isHidden      = false
            statusLabel.text          = "New"
        case .updated:
            statusLabelWidth.constant = updatedStatusLabelWidth
            statusLabel.isHidden      = false
            statusLabel.text          = "Updated"
        case .comingSoon:
            statusLabelWidth.constant = comingSoonStatusLabelWidth
            statusLabel.isHidden      = false
            statusLabel.text          = "Coming Soon"
        case .none:
            statusLabel.isHidden      = true
        }
    }

    public func setIcon(_ image: UIImage?) {
        iconImageView.image = image
    }
    
    public func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    public func setBody(_ body: String?) {
        bodyLabel.text = body
    }
    
}
