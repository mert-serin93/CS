//
//  CircleView.swift
//  ClearScore
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol CircleViewDelegate: AnyObject{
    func onTappedDetailButton(with viewModel: CreditScoreResponseModel)
}

class CircleView: UIView {

    enum Constants {
        static let innerCircleMargin: CGFloat = 25.0
        static let outsideCircleMargin: CGFloat = 10.0
    }

    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private let creditScoreLabel = UILabel()
    private let errorLabel = UILabel()
    private let detailButton = UIButton()

    let outsideCircleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.black.cgColor
        circle.lineWidth = 2.5

        circle.strokeEnd = 1.0
        return circle
    }()

    let circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.red.cgColor
        circle.lineWidth = 5.0

        circle.strokeEnd = 0.0
        return circle
    }()

    private unowned let delegate: CircleViewDelegate?
    private var viewModel: CreditScoreResponseModel?
    private var ratio: Double = 0.0 {
        didSet{
            animateCircle(duration: 2.0)
        }
    }
    private var state: DashboardViewController.State = .loading{
        didSet {
            setupViews()
        }
    }

    init(delegate: CircleViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()

        let outsideCirclePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0,
                                                                y: frame.size.height / 2.0),
                                             radius: (frame.size.width - Constants.outsideCircleMargin)/2,
                                             startAngle: 0.0,
                                             endAngle: CGFloat(Double.pi * 2.0),
                                             clockwise: true)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0,
                                                         y: frame.size.height / 2.0),
                                      radius: (frame.size.width - Constants.innerCircleMargin)/2,
                                      startAngle: CGFloat(Double.pi * 1.5),
                                      endAngle: CGFloat(ratio),
                                      clockwise: true)


        outsideCircleLayer.path = outsideCirclePath.cgPath
        circleLayer.path = circlePath.cgPath
    }

    private func animateCircle(duration t: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = t

        animation.fromValue = 0
        animation.toValue = 1

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        circleLayer.strokeEnd = 1.0

        circleLayer.add(animation, forKey: "animateCircle")
    }

    func update(with state: DashboardViewController.State?) {
        guard let state = state else { return }
        self.state = state
    }

    private func setup(with viewModel: CreditScoreResponseModel) {
        let text = String(format: NSLocalizedString("Your credit score is\n\n %@ \n\nout of 700",
                                                    comment: "credit score label text"),
                          arguments: ["\(viewModel.creditReportInfo.score)"])

        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "\(viewModel.creditReportInfo.score)", options: .caseInsensitive)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : getCreditScoreColor(score: viewModel.creditReportInfo.score), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)], range: range)

        creditScoreLabel.attributedText = attributedString
        calculateRatio(score: viewModel.creditReportInfo.score)
    }

    private func calculateRatio(score: Int){
        ratio = (Double(score) / 700.0 * 2.0) + 1.5
    }

    private func getCreditScoreColor(score: Int) -> UIColor {
        switch score {
        case Int.min...200:
            creditScoreLabel.accessibilityLabel = "CreditScoreLow"
            return .red
        case 201...550:
            creditScoreLabel.accessibilityLabel = "CreditScoreMedium"
            return .orange
        default:
            creditScoreLabel.accessibilityLabel = "CreditScoreHigh"
            return .green
        }
    }
}

extension CircleView: ViewSetup {
    func addSubviews() {
        [activityIndicator, creditScoreLabel, detailButton].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })

        backgroundColor = UIColor.clear

        layer.addSublayer(outsideCircleLayer)
        layer.addSublayer(circleLayer)

        creditScoreLabel.numberOfLines = 0
        creditScoreLabel.textAlignment = .center

        detailButton.addTarget(self, action: #selector(onTappedButton), for: .touchUpInside)
    }

    func setupViews() {
        errorLabel.isHidden = true
        switch state {
        case .loading:
            activityIndicator.isHidden = false
            creditScoreLabel.isHidden = true

            activityIndicator.startAnimating()
        case .loaded(let viewModel):
            activityIndicator.isHidden = true
            creditScoreLabel.isHidden = false

            activityIndicator.stopAnimating()
            self.viewModel = viewModel
            setup(with: viewModel)
        case .error:
            errorLabel.isHidden = false
            break
        }
    }

    func setupConstraints() {
        activityIndicator.centerToContainer()
        creditScoreLabel.centerToContainer()
        errorLabel.centerToContainer()
        detailButton.fillContainer()

        NSLayoutConstraint.activate(
            [
                creditScoreLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -Constants.innerCircleMargin),
                creditScoreLabel.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -Constants.innerCircleMargin),
            ]
        )
    }

    func setupAccessibilityIdentifiers() {
        self.accessibilityLabel = "CircleView"
        activityIndicator.accessibilityLabel = "CircleViewActivityIndicator"
        creditScoreLabel.accessibilityLabel = "CircleViewScoreLabel"
        detailButton.accessibilityLabel = "CircleViewDetailButton"
    }

}

@objc
private extension CircleView {
    private func onTappedButton() {
        guard let viewModel = viewModel else { return }
        delegate?.onTappedDetailButton(with: viewModel)
    }
}
