//
//  EpisodeDetailsController.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import UIKit
import Combine
import AVFoundation
import APMCCore

final class EpisodeDetailsController: UIViewController {
    // MARK: Lifecycle

    init(episode: EpisodeViewModel) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        self.setup()
        print("EpisodeDetailsController initialized")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("EpisodeDetailsController deinitialized")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.subscriptions.removeAll()
        self.playerManager.removeObservers()
        self.playerView.player?.pause()
        self.playerView.player = nil
    }

    // MARK: Private

    private let episode: EpisodeViewModel
    private let playerManager = PlayerManager()
    private var subscriptions = Set<AnyCancellable>()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let playerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addConstraints([
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 16 / 9),
        ])
        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        return spinner
    }()

    private let placeholderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "video")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.addConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.heightAnchor.constraint(equalToConstant: 128),
        ])
        return imageView
    }()

    private func setup() {
        self.view.backgroundColor = .systemBackground

        [self.spinner, self.placeholderView].forEach {
            self.playerView.addSubview($0)
        }

        [self.titleLabel, self.descriptionLabel, self.playerView, self.durationLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)

        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),

            self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.view.widthAnchor, priority: .defaultLow),

            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            self.spinner.centerXAnchor.constraint(equalTo: self.playerView.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor),
        ])
    }

    private func configure() {
        self.titleLabel.text = self.episode.title
        self.descriptionLabel.text = self.episode.description
        self.descriptionLabel.isHidden = !self.episode.hasDescriptipn
        self.durationLabel.text = self.episode.durationText

        if let url = episode.url {
            self.placeholderView.isHidden = true
            self.spinner.startAnimating()
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            self.addPlayerObservers(player: player)
            self.playerView.player = player
        }
        else {
            self.placeholderView.isHidden = false
        }
    }

    private func addPlayerObservers(player: AVPlayer) {
        self.playerManager.addObservers(player: player)

        self.playerManager
            .onPaybackReady
            .sink { player.play() }
            .store(in: &self.subscriptions)

        self.playerManager
            .onPaybackFailed
            .sink { [weak self] message in
                guard let self else { return }
                self.spinner.stopAnimating()
                self.placeholderView.isHidden = false
                if let message {
                    self.showAlert(message)
                }
            }
            .store(in: &self.subscriptions)

        self.playerManager
            .onPaybackStarted
            .sink { [weak self] in self?.spinner.stopAnimating() }
            .store(in: &self.subscriptions)

        self.playerManager
            .onPaybackPaused
            .sink { [weak self] in self?.spinner.startAnimating() }
            .store(in: &self.subscriptions)
    }
}
