
//
//  NibDesignable.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import UIKit

public protocol NibDesignableProtocol: NSObjectProtocol {
    // MARK: - Nib loading
    /**
     Called to load the nib in setupNib().
     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView
    /**
     Called in the default implementation of loadNib(). Default is class name.
     - returns: Name of a single view nib file.
     */
    func nibName() -> String
}

extension NibDesignableProtocol {
    // MARK: - Nib loading
    /**
     Called to load the nib in setupNib().
     - returns: UIView instance loaded from a nib file.
     */
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView // swiftlint:disable:this force_cast
    }
    
    // MARK: - Nib loading
    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    fileprivate func setupNib(in container: UIView) {
        let view = self.loadNib()
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
}

extension UIView {
    public var nibContainerView: UIView {
        return self
    }
    /**
     Called in the default implementation of loadNib(). Default is class name.
     - returns: Name of a single view nib file.
     */
    open func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
}

@IBDesignable
open class NibDesignable: UIView, NibDesignableProtocol {
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(in: self)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self)
    }
}

@IBDesignable
open class NibDesignableTableViewCell: UITableViewCell, NibDesignableProtocol {
    // MARK: - Initializer
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupNib(in: self.contentView)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self.contentView)
    }
}

@IBDesignable
open class NibDesignableTableViewHeaderFooterView: UITableViewHeaderFooterView, NibDesignableProtocol {
    // MARK: - Initializer
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupNib(in: self)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self)
    }
}

@IBDesignable
open class NibDesignableControl: UIControl, NibDesignableProtocol {
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(in: self)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self)
    }
}

@IBDesignable
open class NibDesignableCollectionReusableView: UICollectionReusableView, NibDesignableProtocol {
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(in: self)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self)
    }
}

@IBDesignable
open class NibDesignableCollectionViewCell: UICollectionViewCell, NibDesignableProtocol {
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(in: self.contentView)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(in: self.contentView)
    }
}

