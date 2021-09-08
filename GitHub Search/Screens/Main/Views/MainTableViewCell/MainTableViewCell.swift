//
//  MainTableViewCell.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit
import SDWebImage

final class MainTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ownerLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Public Properties
    
    var repository: Repository! {
        didSet {
            configure()
        }
    }
    
    // MARK: Private Methods
    
    private func configure() {
        avatarImageView.sd_setImage(with: repository.ownerAvatarURL)
        nameLabel.text = repository.name
        ownerLabel.text = repository.ownerName
        starCountLabel.text = "\(repository.numberOfStars)"
        descriptionLabel.text = repository.description
    }
    
}
