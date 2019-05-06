//
//  MovieTableViewCell.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import UIKit
import PureLayout
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    // MARK: - Public variable
    
    private let inset : CGFloat = 15.0
    
    var model: Movie? {
        didSet {
            if let movie = model {
                loadingSpinner.stopAnimating()
                nameLabel.text = movie.title
                overviewLabel.text = movie.overview
                posterImageView.sd_setImage(with: model?.posterURL(), completed: nil)
            }else{
                loadingSpinner.startAnimating()
                nameLabel.text = ""
                overviewLabel.text = ""
                posterImageView.image = nil
            }
        }
    }
    
    // MARK: - Private variable
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView.newAutoLayout()
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 10.0
        
        return labelsStackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView.newAutoLayout()
        imageView.image = nil
        
        return imageView
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView.newAutoLayout()
        spinner.style = .gray
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupLayer()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        setupLayer()
        setupConstraints()
    }
    
    // MARK: - Setup
    func setup() {
    }
    
    // MARK: - Setup Layer
    func setupLayer() {
        contentView.addSubview(labelsStackView)
        contentView.addSubview(loadingSpinner)
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(overviewLabel)
        
        contentView.addSubview(posterImageView)
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        setupLabelsStackViewConstraints()
        setupNameLabelConstraints()
        setUpPosterImageViewConstraints()
        setupLoadingSpinnerConstraints()
    }
    
    private func setUpPosterImageViewConstraints() {
        posterImageView.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        posterImageView.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        posterImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: (inset - 1), relation: .greaterThanOrEqual)
        
        labelsStackView.autoPinEdge(.left, to: .right, of: posterImageView, withOffset: inset)
        posterImageView.autoMatch(.height, to: .width, of: posterImageView, withMultiplier: (4.0/3.0))
        posterImageView.autoSetDimension(.height, toSize: MovieTableViewCell.normalHeight() - (2 * inset))
    }
    
    private func setupLabelsStackViewConstraints() {
        labelsStackView.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        labelsStackView.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        labelsStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: inset)
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.autoSetPriority(.required) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.nameLabel.autoSetContentHuggingPriority(for: .vertical)
            strongSelf.nameLabel.autoSetContentCompressionResistancePriority(for: .vertical)
        }
    }
    
    private func setupLoadingSpinnerConstraints() {
        loadingSpinner.autoSetDimension(.height, toSize: 20.0)
        loadingSpinner.autoMatch(.height, to: .width, of: loadingSpinner, withMultiplier: 1)
        loadingSpinner.autoAlignAxis(toSuperviewAxis: .vertical)
        loadingSpinner.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    // MARK: - Public
    class func defaultReuseIdentifier() -> String {
        let klass: AnyClass = object_getClass(self)!
        return NSStringFromClass(klass)
    }
    
    class func normalHeight() -> CGFloat {
        return 200.0
    }
}

