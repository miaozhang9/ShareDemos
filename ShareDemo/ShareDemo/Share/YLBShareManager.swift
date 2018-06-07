//
//  YLBShareManager.swift
//  YLBEE
//
//  Created by 郭阳阳(金融壹账通客户端研发团队) on 2018/3/22.
//  Copyright © 2018年 冯铁军. All rights reserved.
//

import Foundation

// MARK: - ShareMessage

/// platform
enum YLBSharePlatformType: Int {
    case noPlatform = 0       //默认值，无效
    case wechatSession        //微信聊天
    case wechatTimeLine       //微信朋友圈
    case wechatFavorite       //微信收藏
}

class YLBShareObject: UMShareWebpageObject {
}

/// message
class YLBShareMessage: UMSocialMessageObject {
    
    // MARK: - attribute & getter & setter
    var itemTitle: String?
    var imageName: String?
    var platformType: YLBSharePlatformType = .noPlatform
    var imageViewSize:CGFloat = 60                                  // Default is 60.
    var titleFontSize: CGFloat = 12                                 // Default is 12.
    var titleColor = UIColor.ylb_withHex(hexString: "#6A6D72")      // Default is 6A6D72.
    var backgroudColor = UIColor.white                              // Default is white.
    
    // MARK: - life cycle
    convenience init(itemTitle: String, imageName: String, platformType: YLBSharePlatformType, imageViewSize: CGFloat = 60, titleFontSize: CGFloat = 12, titleColor: UIColor = UIColor.ylb_withHex(hexString: "#6A6D72"), backgroudColor: UIColor = UIColor.white) {
        self.init()
        self.itemTitle = itemTitle
        self.imageName = imageName
        self.platformType = platformType
        self.imageViewSize = imageViewSize
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.backgroudColor = backgroudColor
    }
}

 // MARK: - Item
class YLBShareItemView: UIView {
    
    // MARK: - attribute & getter & setter
    let imageView: UIImageView
    let titleLabel: UILabel
    let button: UIButton
    var touchItemBlock: ((_ button: UIButton) -> Void)?
    
    var itemMessage: YLBShareMessage?
    
    // MARK: - life cycle
    override init(frame: CGRect) {
    
        imageView = UIImageView.init()
        titleLabel = UILabel.init()
        button = UIButton.init(type: .custom)
        touchItemBlock = nil
        super.init(frame: frame)
        
        button.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(button)
    }
    
    convenience init(frame: CGRect, message: YLBShareMessage) {
        self.init(frame: frame)
        self.itemMessage = message
        
        self.imageView.image = UIImage.init(named: self.itemMessage?.imageName ?? "")
        self.titleLabel.text = self.itemMessage?.itemTitle
        self.titleLabel.font = UIFont.systemFont(ofSize: self.itemMessage?.titleFontSize ?? 12)
        self.titleLabel.textColor = self.itemMessage?.titleColor ?? UIColor.ylb_withHex(hexString: "#6A6D72")
        self.backgroundColor = self.itemMessage?.backgroudColor ?? UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - override superMethod
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = self.itemMessage?.imageViewSize ?? 60
        let margin = (self.bounds.width - imageSize) / 2
        self.imageView.frame = CGRect.init(x: margin, y: 0, width: imageSize, height: imageSize)
        let titleLabelHeight = (self.itemMessage?.titleFontSize ?? 12) + 2
        self.titleLabel.frame = CGRect.init(x: 0, y: self.bounds.height - titleLabelHeight, width: self.bounds.width, height: titleLabelHeight)
        self.button.frame = self.bounds
    }
    // MARK: - event reponse
    @objc private func buttonClick(sender: UIButton) {
        guard let block = self.touchItemBlock else {
            return
        }
        block(sender)
    }
}

// MARK: - YLBShareManager

/// protocol
protocol YLBShareManagerProtocol: NSObjectProtocol {
    func touchItem(itemMessage: YLBShareMessage)
}

/// attribute
class YLBShareManagerAttribute {
    
    var itemArray: [YLBShareMessage]?
    var columns = 4
    var itemSize = CGSize.init(width: 60, height: 90)
    var maskBackgroudViewColor = UIColor.ylb_withHex(hexString: "#000000", alpha: 0.4)
    var closeButtonTitle = "关闭"
    var closeButtonTitleColor = UIColor.white
    var closeButtonBackgroundColor = UIColor.clear
    var closeButtonFont = UIFont.systemFont(ofSize: 12)
    var closeButtonSize = CGSize.init(width: 50, height: 17)
    var itemContainerViewBackgroundColor = UIColor.white
    
    
    convenience init(itemArray: [YLBShareMessage]?, columns: Int = 4, itemSize: CGSize = CGSize.init(width: 60, height: 90), maskBackgroudViewColor: UIColor = UIColor.ylb_withHex(hexString: "#000000", alpha: 0.4), closeButtonTitle: String = "关闭", closeButtonTitleColor: UIColor = UIColor.white, closeButtonBackgroundColor: UIColor = UIColor.clear, closeButtonFont: UIFont =  UIFont.systemFont(ofSize: 12), closeButtonSize: CGSize = CGSize.init(width: 50, height: 17), itemContainerViewBackgroundColor: UIColor = UIColor.white) {
        self.init()
        self.itemArray = itemArray
        self.columns = columns
        self.itemSize = itemSize
        self.maskBackgroudViewColor = maskBackgroudViewColor
        self.closeButtonTitle = closeButtonTitle
        self.closeButtonBackgroundColor = closeButtonBackgroundColor
        self.closeButtonFont = closeButtonFont
        self.closeButtonSize = closeButtonSize
        self.itemContainerViewBackgroundColor = itemContainerViewBackgroundColor
    }
    
    public class func defaultShareManagerAttribute() -> YLBShareManagerAttribute {
        let session = YLBShareMessage.init(itemTitle: "微信好友", imageName: "share_wechatSession", platformType: .wechatSession)
        let timeLine = YLBShareMessage.init(itemTitle: "朋友圈", imageName: "share_wechatTimeLine",platformType: .wechatTimeLine)
        return YLBShareManagerAttribute.init(itemArray: [timeLine, session])
    }
}

/// manager
class YLBShareManager: UIView {
    
    // MARK: - attribute & getter & setter
    weak var delegate: YLBShareManagerProtocol?
    var attribute: YLBShareManagerAttribute
    
    let itemContainerView: UIView
    let closeButton: UIButton
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        
        itemContainerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0))
        closeButton = UIButton.init(type: .custom)
        attribute = YLBShareManagerAttribute.init()
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let tapGesure = UITapGestureRecognizer.init(target: self, action: #selector(close))
        self.addGestureRecognizer(tapGesure)
        closeButton.contentMode = UIViewContentMode.right
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.addSubview(closeButton)
        self.addSubview(itemContainerView)
    }
    
    convenience init(frame: CGRect, attribute: YLBShareManagerAttribute, delegate: YLBShareManagerProtocol?) {
        self.init(frame: frame)
        self.delegate = delegate
        self.attribute = attribute
        self.ylb_setupAttribues()
        self.ylb_setUpItemsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - event reponse
    @objc private func close() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.clear
            self.closeButton.backgroundColor = UIColor.clear
            self.itemContainerView.frame.origin.y = self.bounds.height
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - notification
    
    // MARK: - public method
    public func show(toView view: UIView?) {
        
        if let toView = view {
            self.frame = toView.bounds
            toView.addSubview(self)
        }else {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            self.frame = window.bounds
            window.addSubview(self)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.closeButton.backgroundColor = self.attribute.closeButtonBackgroundColor
            self.backgroundColor = UIColor.ylb_withHex(hexString: "#000000", alpha: 0.4)
            self.itemContainerView.frame.origin.y = self.bounds.height - self.itemContainerView.bounds.height + 5
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.itemContainerView.frame.origin.y = self.bounds.height - self.itemContainerView.bounds.height
            }, completion: nil)
        }
        
    }
    
    public func hide() {
        self.close()
    }
    // MARK: - private method
    private func ylb_setupAttribues() {
        self.closeButton.setTitleColor(self.attribute.closeButtonTitleColor, for: .normal)
        self.closeButton.setTitle(self.attribute.closeButtonTitle, for: .normal)
        self.closeButton.backgroundColor = UIColor.clear
        self.itemContainerView.backgroundColor = self.attribute.itemContainerViewBackgroundColor
    }
    
    private func ylb_setUpItemsView() {
        ///行数
        var rows = 0
        ///列数
        let columns = self.attribute.columns
        ///item总个数
        let itemsTotalCount = self.attribute.itemArray?.count ?? 0
        ///行间距
        let lineSpacing: CGFloat = 20
        ///列间距
        var columnSpacing: CGFloat = 0
        ///itme上间距
        let topSpacing: CGFloat = 18
        ///itme底间距
        let bottomSpacing: CGFloat = 22
        ///itemSize
        let itemHeight = self.attribute.itemSize.height
        let itemWidth = self.attribute.itemSize.width
        ///item容器的高
        var itemContainerViewHeight: CGFloat = topSpacing + bottomSpacing + itemHeight
        
        
        if itemsTotalCount != 0 && columns != 0 {
            rows = itemsTotalCount / columns + ((itemsTotalCount % columns == 0) ? 0 : 1)
            itemContainerViewHeight =  itemContainerViewHeight + (lineSpacing + itemHeight) * CGFloat.init(rows - 1)
            columnSpacing = (self.bounds.width - itemWidth * 4) / 5
        }
        
        self.itemContainerView.frame = CGRect.init(x: 0, y: self.bounds.height, width: self.bounds.width, height: itemContainerViewHeight)
        if itemsTotalCount != 0 && columns != 0 {
            
            for subView in self.itemContainerView.subviews {
                subView.removeFromSuperview()
            }
            
            guard let itemObjectArray = self.attribute.itemArray else {
                return
            }
            var itemX: CGFloat = 0
            var itemY: CGFloat = 0
            for (index, item) in itemObjectArray.enumerated() {
                
                itemX = columnSpacing * CGFloat.init(index % columns + 1) + itemWidth * CGFloat.init(index % columns)
                var currentRow = 0
                if (index + 1) % columns == 0 {
                    currentRow = (index + 1) / columns - 1
                }else {
                    currentRow = (index + 1) / columns
                }
                itemY = topSpacing + (lineSpacing + itemHeight) * CGFloat.init(currentRow)
                let itemView = YLBShareItemView.init(frame: CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight), message: item)
                itemView.touchItemBlock = { [weak self] (sender) -> Void in
                    self?.delegate?.touchItem(itemMessage: item)
                    self?.close()
                }
                self.itemContainerView.addSubview(itemView)
            }
        }
        
        ///closeView frame
        self.closeButton.frame = CGRect.init(x: self.bounds.width - self.attribute.closeButtonSize.width - 17, y: self.bounds.height - itemContainerViewHeight - 10 - self.attribute.closeButtonSize.height, width: self.attribute.closeButtonSize.width, height: self.attribute.closeButtonSize.height)
    }
}

// MARK: - UIColor Category
/// 获取颜色的方法
extension UIColor {
    /**
     获取颜色，通过16进制色值字符串，e.g. #ff0000， ff0000
     - parameter hexString  : 16进制字符串
     - parameter alpha      : 透明度，默认为1，不透明
     - returns: RGB
     */
    static func ylb_withHex(hexString hex: String, alpha:CGFloat = 1) -> UIColor {
        // 去除空格等
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        // 必须为6位
        if (cString.count != 6) {
            return UIColor.gray
        }
        // 红色的色值
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
