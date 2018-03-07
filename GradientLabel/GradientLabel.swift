import UIKit

@IBDesignable public class GradientLabel: UIView {
    
    @IBInspectable public var text: String? { didSet { update() } }
    @IBInspectable public var font: UIFont? { didSet { update() } }
    
    @IBInspectable public var startColor: UIColor? { didSet { update() } }
    @IBInspectable public var endColor: UIColor? { didSet { update() } }
    
    @IBInspectable public var startPoint: CGPoint = GradientLabel.defaultStartPoint { didSet { update() } }
    @IBInspectable public var endPoint: CGPoint = GradientLabel.defaultEndPoint { didSet { update() } }
    
    // MARK: Private
    
    private static let defaultFont = UIFont.boldSystemFont(ofSize: 30.0)
    private static let defaultStartColor = UIColor.blue
    private static let defaultEndColor = UIColor.red
    private static let defaultStartPoint = CGPoint(x: 0.0, y: 0.5)
    private static let defaultEndPoint = CGPoint(x: 1.0, y: 0.5)

    private let maskLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.highlightedTextColor = .black
        label.shadowColor = .clear
        label.backgroundColor = .clear
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        gradientLayer.frame = layer.bounds
        layer.addSublayer(gradientLayer)
        mask = maskLabel
        update()
    }
    
    private func update() {
        maskLabel.text = text
        maskLabel.font = font ?? GradientLabel.defaultFont
        maskLabel.sizeToFit()
        invalidateIntrinsicContentSize()
        
        let start: UIColor = startColor ?? GradientLabel.defaultStartColor
        let end: UIColor = endColor ?? GradientLabel.defaultEndColor
        withoutImplicitAnimation {
            gradientLayer.colors = [start.cgColor, end.cgColor]
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return maskLabel.intrinsicContentSize
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        withoutImplicitAnimation {
            gradientLayer.frame = layer.bounds
        }
    }
    
    private func withoutImplicitAnimation(block: (() -> Void)) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        block()
        CATransaction.commit()
    }
    
}
