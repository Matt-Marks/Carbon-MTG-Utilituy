//
//  UIMenuHistoryViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIMenuHistoryViewController: UIPageViewControllerPage {

    /////////////////////////////////////
    // MARK: Variables: Interface Outlets
    /////////////////////////////////////
    @IBOutlet weak var historyTableView: UITableView!
    
    ///////////////////////////////////
    // MARK: Variables: Separator Lines
    ///////////////////////////////////
    private let separatorLineWidth: CGFloat = 1.5
    private var separatorLineColor: UIColor = .white
    private var topSeparatorLine = UIView()
    private var horizontalSeparatorLines = [UIView]()
    
    //////////////////////////////
    // MARK: Variables: Table View
    //////////////////////////////
    private let rowHeight: CGFloat         = 70
    private let largeImageSize: CGFloat    = 50
    private let labelWidth: CGFloat        = 80
    private let labelHeight: CGFloat       = 40
    private let labelYOrigin: CGFloat      = 5
    private let smallImageWidth: CGFloat   = 40
    private let smallImageHeight: CGFloat  = 40
    private let smallImageYOrigin: CGFloat = 0
    private let iconSize: CGFloat          = 30
    private let iconYOrigin: CGFloat       = 35
    private let font: UIFont               = UIFont.dense(size: 40)
    
    //////////////////////////////////////
    // MARK: Variables: Computed Variables
    //////////////////////////////////////
    private var game: UIGameViewController {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController as! UIGameViewController
    }
    
    //////////////////
    // MARK: Lifecycle
    //////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForEntranceAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTopSeparatorLine()
        configureHorizontalSeparatorLines()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }

    ////////////////////////
    // MARK: Seperator Lines
    ////////////////////////
    private func configureTopSeparatorLine() {
        let origin = CGPoint(x: 0, y: historyTableView.frame.origin.y)
        let size   = CGSize(width: view.bounds.width, height: separatorLineWidth)
        let frame  = CGRect(origin: origin, size: size)
        topSeparatorLine.frame           = frame
        topSeparatorLine.backgroundColor = separatorLineColor
        view.addSubview(topSeparatorLine)
    }
    
    private func configureHorizontalSeparatorLines() {
        for i in 1..<game.numberOfPlayers {
            let columnWidth = view.bounds.width/CGFloat(game.numberOfPlayers)
            let xOrigin     = (CGFloat(i) * columnWidth) - separatorLineWidth/2
            let yOrigin     = historyTableView.frame.origin.y
            let width       = separatorLineWidth
            let height      = historyTableView.frame.height
            let origin      = CGPoint(x: xOrigin, y: yOrigin)
            let size        = CGSize(width: width, height: height)
            let lineView    = UIView()
            lineView.frame           = CGRect(origin: origin, size: size)
            lineView.backgroundColor = separatorLineColor
            view.addSubview(lineView)
        }
    }
    
    ////////////////////////////////
    // MARK: History Table View Cell
    ////////////////////////////////
    
    // The rows in the parameter are the rows in the table view. Each row
    // corresponds with a unique event time. The times can be found in the
    // transcribedTimes array. The row is the index of the time.
    //
    // Each player in the history has its own column. The col parameter
    // is used as an index to identify the player.
    //
    // If the player has an event at the given time, this returns a view that
    // will be placed as a subview in the tableview's row. This view contains
    // the entry for that time. If the player does not have an event for the
    // given time, this returns nil.
    private func getContentView(row: Int, col: Int) -> UIView? {
        let player = game.getPlayer(atIndex: col)
        let time   = game.getTranscribedTimes()[row]
        
        // If the player has an event at the given time...
        if game.getPlayers(withEventAtTime: time).contains(player) {
            
            // We create a view that will present the data from the event.
            let content  = UIView()
            let colWidth = view.bounds.width/CGFloat(game.numberOfPlayers)
            let xOrigin  = (CGFloat(col) * colWidth) - separatorLineWidth/2
            let width    = colWidth
            let height   = rowHeight
            let origin   = CGPoint(x: xOrigin, y: 0)
            let size     = CGSize(width: width, height: height)
            let event    = game.getEvent(forPlayer: player, atTime: time)
            
            // It is the same width as the column & the same height as the row.
            content.frame = CGRect(origin: origin, size: size)
            
            // We populate the content with subviews containing the information
            // contained in the event.
            populateContentView(contentView: content,
                                event: event,
                                color: player.getColor())
            
            // This adds marker lines to the left and right of the cell.
            if game.numberOfPlayers > 1 { // One player never has the marker lines.
                
                // The rightmost cells dont have the right line.
                if (col == 0 || col != game.numberOfPlayers-1) {
                    addRightMarkerLine(contentView: content)
                }
                
                // The leftmost cells dont have the left line.
                if col != 0 {
                    addLeftMarkerLine(contentView: content)
                }
            }

            
            return content
        } else {
            // If the player does not have an event for the given time we
            // return nothing.
            return nil
        }
    }
    
    // This takes the information in the given event and adds subviews
    // representing that information to the given content view. The subviews
    // are colored/tinted the color of the player. That color is given by the
    // color parameter.
    private func populateContentView(contentView: UIView,
                                     event: HistoryItem,
                                     color: UIColor) {

        // There are three ways a cell can be populated.
        // First, the cell could be just an image. This happens if the cell
        // represents a player effect such as monarch, citys blessing, or
        // player death. We call this a 'Large Image'.
        let isJustImage = event.image != nil && event.icon == nil
        
        // Second, the cell can be an value and an icon. This is used when
        // the cell represents the change of a counter's value. The value will
        // be added to the cell as a label, and the counter's icon will be added
        // under the label.
        let isValueAndIcon = event.value != nil && event.icon != nil
        
        // Finally, the cell can be an image and an icon. This is used when the
        // cell represents a counter going infinite. The image is either
        // positive or negative infinity, and the icon is the counter's icon.
        let isImageAndIcon = event.image != nil && event.icon != nil
        
        // Depending on which of the three ways the cell should be populated,
        // it is populated accordingly.
        if isJustImage {
            addLargeImage(contentView: contentView, image: event.image!, color: color)
        } else if isValueAndIcon {
            addLabel(contentView: contentView, value: event.value!, color: color)
            addIcon(contentView: contentView, icon: event.icon!, color: color)
        } else if isImageAndIcon {
            addSmallImage(contentView: contentView, image: event.image!, color: color)
            addIcon(contentView: contentView, icon: event.icon!, color: color)
        }
    }
    
    // This adds a large icon centered in the given content view. The image here
    // will always be either the citys blessing, monarch, or player death icon.
    private func addLargeImage(contentView: UIView, image: UIImage, color: UIColor) {
        let imageView       = UIImageView()
        let xOrigin         = contentView.frame.width/2 - largeImageSize/2
        let yOrigin         = contentView.frame.height/2 - largeImageSize/2
        let origin          = CGPoint(x: xOrigin, y: yOrigin)
        let size            = CGSize(width: largeImageSize, height: largeImageSize)
        imageView.image     = image
        imageView.tintColor = color
        imageView.frame     = CGRect(origin: origin, size: size)
        contentView.addSubview(imageView)
    }
    
    // This adds a label that roughly fills the top half of the cell. The label
    // contains the counters value post-change.
    private func addLabel(contentView: UIView, value: Int, color: UIColor) {
        let label           = UILabel()
        let xOrigin         = contentView.frame.width/2 - labelWidth/2
        let origin          = CGPoint(x: xOrigin, y: labelYOrigin)
        let size            = CGSize(width: labelWidth, height: labelHeight)
        label.text          = value.description
        label.textColor     = color
        label.textAlignment = .center
        label.font          = font
        label.frame         = CGRect(origin: origin, size: size)
        contentView.addSubview(label)
    }
    
    // This adds a small icon that roughly fills the top half of the cell. This is
    // mainly used for the positive and negative infinity images that counters
    // use to go infinite.
    private func addSmallImage(contentView: UIView, image: UIImage, color: UIColor) {
        let imageView       = UIImageView()
        let xOrigin         = contentView.frame.width/2 - smallImageHeight/2
        let origin          = CGPoint(x: xOrigin, y: smallImageYOrigin)
        let size            = CGSize(width: smallImageWidth, height: smallImageHeight)
        imageView.image     = image
        imageView.tintColor = color
        imageView.frame     = CGRect(origin: origin, size: size)
        contentView.addSubview(imageView)
    }
    
    // This adds an icon under either the label or the small image that is in
    // the cell. This icon represents the icon of the counter that was changed.
    private func addIcon(contentView: UIView, icon: UIImage, color: UIColor) {
        let iconView       = UIImageView()
        let xOrigin        = contentView.frame.width/2 - iconSize/2
        let origin         = CGPoint(x: xOrigin, y: iconYOrigin)
        let size           = CGSize(width: iconSize, height: iconSize)
        iconView.image     = icon
        iconView.tintColor = color
        iconView.frame     = CGRect(origin: origin, size: size)
        contentView.addSubview(iconView)
    }
    
    // Adds a marker line to the left side of the cel.
    private func addLeftMarkerLine(contentView: UIView) {
        let marker   = CALayer()
        let yOrigin  = contentView.frame.height/2 - separatorLineWidth/2
        let width    = contentView.frame.width/6
        let height   = separatorLineWidth
        marker.frame = CGRect(x: 0, y: yOrigin, width: width, height: height)
        marker.backgroundColor = separatorLineColor.cgColor
        contentView.layer.addSublayer(marker)
    }
    
    // Adds a marker line to the right side of the cel.
    private func addRightMarkerLine(contentView: UIView) {
        let marker   = CALayer()
        let xOrigin  = contentView.frame.width - (contentView.frame.width/6)
        let yOrigin  = contentView.frame.height/2 - separatorLineWidth/2
        let width    = contentView.frame.width/6
        let height   = separatorLineWidth
        marker.frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
        marker.backgroundColor = separatorLineColor.cgColor
        contentView.layer.addSublayer(marker)
    }
    
    ///////////////////
    // MARK: Animations
    ///////////////////
    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .history {
            for subview in view.subviews {
                subview.prepareForEntranceAnimation()
            }
        }
    }
    
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .history {
            for subview in view.subviews {
                subview.performEntranceAnimation()
            }
        }
    }
    
}

extension UIMenuHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        for i in 0..<game.numberOfPlayers {
            if let content = getContentView(row: indexPath.row, col: i) {
                cell.addSubview(content)
            }
        }
        
        
    }
}

extension UIMenuHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return game.getTranscribedTimes().count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
