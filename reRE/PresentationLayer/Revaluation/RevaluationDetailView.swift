//
//  RevaluationDetailView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/23.
//

import UIKit
import Then
import SnapKit
import DGCharts

final class RevaluationDetailView: UIStackView {
    private lazy var gradeContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var gradeTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var gradeLabel = UILabel().then {
        $0.textColor = ColorSet.primary(.orange60).color
        $0.font = FontSet.display01.font
    }
    
    private lazy var gradeImageStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var chartContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var chartTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
        $0.text = "최근 5개월 간 평점 추이"
    }
    
    private lazy var chartView = LineChartView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        spacing = moderateScale(number: 48)
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([gradeContainerView, chartContainerView])
        gradeContainerView.addSubviews([gradeTitleLabel, gradeLabel, gradeImageStackView])
        chartContainerView.addSubviews([chartTitleLabel, chartView])
        
        for _ in 0..<5 {
            let gradeImageView: UIImageView = UIImageView()
            gradeImageView.contentMode = .scaleAspectFit
            gradeImageView.image = UIImage(named: "GradeStar")?.withTintColor(ColorSet.gray(.gray40).color!,
                                                                              renderingMode: .alwaysTemplate)
            
            gradeImageStackView.addArrangedSubview(gradeImageView)
        }
    }
    
    private func makeConstraints() {
        gradeTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        gradeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeTitleLabel.snp.bottom).offset(moderateScale(number: 24))
        }
        
        gradeImageStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.bottom.equalToSuperview()
        }
        
        gradeImageStackView.arrangedSubviews.forEach { subView in
            subView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 28))
            }
        }
        
        chartTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(chartTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 300))
        }
    }
    
    func updateGradeView(ofDate DateString: String, grade: CGFloat) {
        gradeTitleLabel.text = DateString
        
        let decimalNumber = Int(grade * 100) / 100
        let floatingNumber: CGFloat = CGFloat(Int(grade * 100) % 100) / 100
        gradeLabel.text = "\(CGFloat(decimalNumber) + floatingNumber)"
        
        for (index, subView) in gradeImageStackView.arrangedSubviews.enumerated() {
            if index < decimalNumber {
                (subView as? UIImageView)?.tintColor = ColorSet.primary(.orange60).color
            } else if index == decimalNumber {
                (subView as? UIImageView)?.fillColor(with: ColorSet.primary(.orange60).color,
                                                     percentage: floatingNumber)
            } else {
                (subView as? UIImageView)?.tintColor = ColorSet.gray(.gray40).color
            }
        }
    }
    
    func updateGradeTrend(grades: [CGFloat]) {
        var dataEntries: [ChartDataEntry] = []
        
        for index in 0..<grades.count {
            let dataEntry = ChartDataEntry(x: Double(index), y: grades[index])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries)
        // chart main settings
//        chartDataSet.mode = .linear // curve smoothing
//        chartDataSet.drawValuesEnabled = false // disble values
//        chartDataSet.drawCirclesEnabled = false // disable circles
//        chartDataSet.drawFilledEnabled = true // gradient setting
        chartDataSet.circleHoleColor = .blue
        
        // settings for picking values on graph
        chartDataSet.drawHorizontalHighlightIndicatorEnabled = false // leave only vertical line
        chartDataSet.highlightLineWidth = 2 // vertical line width
        // 차트 컬러
        //        chartDataSet.colors = [.systemBlue]
//        chartDataSet.colors = [.green]
        
        chartDataSet.setColor(ColorSet.primary(.orange60).color!)
        chartDataSet.setCircleColor(.red)
        // 데이터 삽입
        //        let chartData = BarChartData(dataSet: chartDataSet)
        //        barChartView.data = chartData
        let chartData = LineChartData(dataSet: chartDataSet)
        
        //        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["1일", "-1일", "-2일", "-3일", "-4일"])
        // 값마다 구분하고 싶은 valueFormatter를 개수만큼 출력
        //        chartView.xAxis.setLabelCount(grades.count, force: false)
        chartView.data = chartData
        
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.leftAxis.drawGridLinesEnabled = false
//        chartView.rightAxis.drawGridLinesEnabled = false
//        chartView.drawGridBackgroundEnabled = false
        // disable axis annotations
//        chartView.xAxis.drawLabelsEnabled = false
//        chartView.leftAxis.drawLabelsEnabled = false
//        chartView.rightAxis.drawLabelsEnabled = false
        // disable legend
        chartView.legend.enabled = false
        // disable zoom
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        // remove artifacts around chart area
//        chartView.xAxis.enabled = false
//        chartView.leftAxis.enabled = false
//        chartView.rightAxis.enabled = false
//        chartView.drawBordersEnabled = false
//        chartView.minOffset = 0
        
        chartView.isUserInteractionEnabled = false
//        super.viewDidLoad()
//            let lineChartEntries = [
//                ChartDataEntry(x: 1, y: 2),
//                ChartDataEntry(x: 2, y: 4),
//                ChartDataEntry(x: 3, y: 3),
//            ]
//            let dataSet = LineChartDataSet(entries: lineChartEntries)
//            let data = LineChartData(dataSet: dataSet)
//            let chart = LineChartView()
//            chart.data = data
//            
//            view.addSubview(chart)
//            chart.snp.makeConstraints {
//                $0.centerY.width.equalToSuperview()
//                $0.height.equalTo(300)
//            }
    }
}
