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
    private var isTimerStarted = false
    private var correctAnswers: [(question: String, answer: Int)] = []
    private var totalAttempts = 0
    private var currentMultiplicand: Int = 0
    private var currentMultiplier: Int = 0
    
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to Start"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        let label = UILabel()
        label.text = "0 x 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellowMainColorAsset ?? .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private let answersVerticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
       verticalStackView.axis = .vertical
       verticalStackView.spacing = 10
       verticalStackView.alignment = .center
       verticalStackView.translatesAutoresizingMaskIntoConstraints = false
       return verticalStackView
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
        timerBar.onTimeUp = {[weak self] in
            guard let self = self else { return }
            let correct = self.correctAnswers.count
            let wrong = self.totalAttempts - correct
            
            self.resultLabel.text = "Correct Answers: \(correct)\nWrong Answers: \(wrong)\n\nTap to start again!"
            
            self.correctAnswers.removeAll()
            self.totalAttempts = 0
            self.showStartBlur()
        }
        

        view.addSubview(timerBar.timerBar)
        setupTimerBarConstraints()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFirstTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
        setupAnswersStackView()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(solveLabel)
        view.addSubview(timesLabel)
        view.addSubview(dividerView)
        view.addSubview(answersVerticalStackView)
        view.addSubview(blurView)
        blurView.contentView.addSubview(startLabel)
        blurView.contentView.addSubview(resultLabel)
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
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 16),
            resultLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor)
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
    
    private func setupAnswersStackView(){
        let firstRow = createHorizontalStackView(buttonTitles: ["", ""])
        let secondRow = createHorizontalStackView(buttonTitles: ["", ""])
        
        answersVerticalStackView.addArrangedSubview(firstRow)
        answersVerticalStackView.addArrangedSubview(secondRow)
        
        NSLayoutConstraint.activate([
            answersVerticalStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 60),
            answersVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answersVerticalStackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func createHorizontalStackView(buttonTitles: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        
        for title in buttonTitles {
            let button = createAnswerButton(title: title)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    private func createAnswerButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22.5
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.yellowMainColorAsset?.cgColor
        button.addTarget(self, action: #selector(answerTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
        
    }
    
    private func showStartBlur() {
        isTimerStarted = false
        
        view.addSubview(blurView)
        blurView.alpha = 0
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.5){
            self.blurView.alpha = 1
        }
    }
    
    private func updateAnswerButtons(with answers: [Int]) {
        var index = 0
        for case let horizontalStack as UIStackView in answersVerticalStackView.arrangedSubviews {
            for case let button as UIButton in horizontalStack.arrangedSubviews {
                if index < answers.count {
                    button.setTitle("\(answers[index])", for: .normal)
                    index += 1
                }
            }
        }
    }

    
    @objc func answerTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text,
            let selectedAnswer = Int(title) else { return }
        
        let correctAnswer = currentMultiplicand * currentMultiplier
        let question = "\(currentMultiplicand) X \(currentMultiplier)"
        
        totalAttempts += 1
        
        if selectedAnswer == correctAnswer {
            correctAnswers.append((question: question, answer: correctAnswer))
            timerBar.adjustTime(-3.2)
        }else{
            timerBar.adjustTime(4)
        }
        
        
        let newTimes = timesService.genTimes()
        currentMultiplicand = newTimes.0
        currentMultiplier = newTimes.1
        timesLabel.text = "\(newTimes.0) X \(newTimes.1)"
        
        let answers = timesService.genAnswer(multiplicand: newTimes.0, multiplier: newTimes.1)
        updateAnswerButtons(with: answers)
        }
            
    @objc private func handleFirstTap(_ sender: UITapGestureRecognizer) {
        if !isTimerStarted {
            isTimerStarted = true
            startTimerOnTap()
            timerBar.startTimer()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0
            }) { _ in
                self.blurView.removeFromSuperview()
            }
        }
    }
    
    @objc func startTimerOnTap() {
        let newTimes = timesService.genTimes()
        timesLabel.text = "\(newTimes.0) X \(newTimes.1)"
        currentMultiplicand = newTimes.0
        currentMultiplier = newTimes.1
        
        let answers = timesService.genAnswer(multiplicand: newTimes.0, multiplier: newTimes.1)
        updateAnswerButtons(with: answers)
        
        
        
    }
}
    
    

