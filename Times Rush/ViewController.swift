//
//  ViewController.swift
//  Times Rush
//
//  Created by Ryan Rouxinol on 16/01/25.
//

import UIKit

class ViewController: UIViewController {
    
    var timerBar: TimerBar!
    var timesService: TimesServices!
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.bgDarkModeAsset ?? .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var solveLabel: UILabel = {
        let label = UILabel()
        label.text = "solve this!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var timesLabel: UILabel = {
        let times = timesService.genTimes()
        let label = UILabel()
        label.text = "\(times.0) X \(times.1)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellowMainColorAsset
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializer
    init(timesService: TimesServices) {
        self.timesService = timesService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        timerBar = TimerBar(totalTime: 30.0)

        view.addSubview(timerBar.timerBar)
        setupTimerBarConstraints()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startTimerOnTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(solveLabel)
        view.addSubview(timesLabel)
        view.addSubview(dividerView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            solveLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            solveLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            solveLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
        ])
        
        NSLayoutConstraint.activate([
            timesLabel.topAnchor.constraint(equalTo: solveLabel.topAnchor, constant: 202),
            timesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            timesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: timesLabel.bottomAnchor, constant: 2),
            dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerView.widthAnchor.constraint(equalToConstant: 350),
            dividerView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupTimerBarConstraints() {
        timerBar.timerBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerBar.timerBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timerBar.timerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerBar.timerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerBar.timerBar.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    @objc func startTimerOnTap() {
        let newTimes = timesService.genTimes()
        
        timesLabel.text = "\(newTimes.0) X \(newTimes.1)"
        timerBar.startTimer()
    }
    
}
