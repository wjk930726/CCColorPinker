//
//  CCColorPinker.swift
//  CCColorPinker
//
//  Created by 王靖凯 on 2017/8/5.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import UIKit

@objc protocol CCColorPinkerDelegete: NSObjectProtocol {
    @objc optional func colorPinker(_ colorPinker: CCColorPinker, didSelectedConfirmButton sender: UIButton)
    @objc optional func colorPinker(_ colorPinker: CCColorPinker, didSelectedCancelButton sender: UIButton)
}

class CCColorPinker: UIView {
    weak var delegete: CCColorPinkerDelegete?

    // 标题label
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(text: "选择颜色", fontSize: 24, color: UIColor.white)
        return label
    }()

    // 取消按钮
    fileprivate lazy var cancelButton: UIButton = {
        let btn = UIButton(title: "取消", fontSize: 20, color: UIColor.colorWithHex(hex: 0x429583), target: self, action: #selector(cancelButtonAction))
        return btn
    }()

    // 确认按钮
    fileprivate lazy var confirmButton: UIButton = {
        let btn = UIButton(title: "确认", fontSize: 20, color: UIColor.colorWithHex(hex: 0x429583), target: self, action: #selector(confrimButtonAction))
        return btn
    }()

    // 灰度滑动条
    fileprivate lazy var greySlider: UISlider = {
        let s = UISlider()
        s.value = 1.0
        return s
    }()

    // 透明度滑动条
    fileprivate lazy var alphaSlider: UISlider = {
        let s = UISlider()
        s.value = 1.0
        return s
    }()

    // 颜色选择盘
    public lazy var colorPlate: CCColorPlate = {
        let cp = CCColorPlate()
        return cp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI相关

extension CCColorPinker {
    fileprivate func setupUI() {
        // 标题
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20))

        // 按钮
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20))
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: confirmButton, attribute: .leading, multiplier: 1, constant: -20))
        addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: confirmButton, attribute: .centerY, multiplier: 1, constant: 0))

        // 滑条
        addSubview(greySlider)
        addSubview(alphaSlider)

        // 自定义滑条
        greySlider.setThumbImage(getThumbImage(radius: 10), for: .normal)
        greySlider.setMinimumTrackImage(getGradientTrackImage(height: 4), for: .normal)
        greySlider.setMaximumTrackImage(getGradientTrackImage(height: 4), for: .normal)

        alphaSlider.setMinimumTrackImage(getTrackImage(color: UIColor.white, height: 4), for: .normal)
        alphaSlider.setMaximumTrackImage(getTrackImage(color: UIColor.white, height: 4), for: .normal)
        alphaSlider.setThumbImage(getThumbImage(radius: 10), for: .normal)

        greySlider.translatesAutoresizingMaskIntoConstraints = false
        alphaSlider.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: greySlider, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: greySlider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: greySlider, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20))
        addConstraint(NSLayoutConstraint(item: greySlider, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.46, constant: 0))

        addConstraint(NSLayoutConstraint(item: alphaSlider, attribute: .centerX, relatedBy: .equal, toItem: greySlider, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: alphaSlider, attribute: .leading, relatedBy: .equal, toItem: greySlider, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: alphaSlider, attribute: .trailing, relatedBy: .equal, toItem: greySlider, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: alphaSlider, attribute: .top, relatedBy: .equal, toItem: greySlider, attribute: .bottom, multiplier: 1, constant: 20))

        addSubview(colorPlate)
        colorPlate.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: colorPlate, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0))
        addConstraint(NSLayoutConstraint(item: colorPlate, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0))
        addConstraint(NSLayoutConstraint(item: colorPlate, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: colorPlate, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.8, constant: 0))
    }
}

// MARK: - 交互相关

extension CCColorPinker {
    @objc fileprivate func cancelButtonAction(sender: UIButton) {
        delegete?.colorPinker?(self, didSelectedCancelButton: sender)
    }

    @objc fileprivate func confrimButtonAction(sender: UIButton) {
        delegete?.colorPinker?(self, didSelectedConfirmButton: sender)
    }
}

// MARK: - 自定义滑条

extension CCColorPinker {
    fileprivate func getTrackImage(color: UIColor, height: CGFloat) -> UIImage {
        let size = CGSize(width: 1, height: height)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(rect)
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return trackImage!
    }

    fileprivate func getThumbImage(radius: CGFloat) -> UIImage {
        let diameter = radius * 2
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: CGPoint(x: diameter * 0.1, y: diameter * 0.1), size: CGSize(width: diameter * 0.8, height: diameter * 0.8))
        UIGraphicsBeginImageContext(size)
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        UIColor.black.setStroke()
        path.lineWidth = diameter * 0.2
        path.stroke()
        path.fill()
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbImage!
    }

    fileprivate func getGradientTrackImage(height: CGFloat) -> UIImage {
        let size = CGSize(width: 40, height: height)
        UIGraphicsBeginImageContext(size)
        let compoents: [CGFloat] = [0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0]
        let locations: [CGFloat] = [0, 1]
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: compoents, locations: locations, count: locations.count)
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient!, start: CGPoint.zero, end: CGPoint(x: 40, y: 0), options: .drawsAfterEndLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
