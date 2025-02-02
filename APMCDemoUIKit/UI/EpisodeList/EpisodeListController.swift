//
//  EpisodesController.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-01.
//

import UIKit
import APMCCore

final class EpisodeListController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        Task {
            await self.loadEpisodes()
        }
    }

    // MARK: Private

    private let viewModel = EpisodeListViewModel()
    private let reuseId = "epideoCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: self.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private func setup() {
        self.title = "Episodes"

        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    private func loadEpisodes() async {
        do {
            try await self.viewModel.load()
            self.tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
            await self.showAlert(error.localizedDescription)
        }
    }
}

extension EpisodeListController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        self.viewModel.episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId, for: indexPath)
        if let episodeCell = cell as? EpisodeCell {
            let episode = self.viewModel.episodes[indexPath.row]
            episodeCell.configure(episode: episode)
        }
        return cell
    }
}

extension EpisodeListController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.viewModel.episodes[indexPath.row]
        let detailsController = EpisodeDetailsController(episode: episode)
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
}

private class EpisodeCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Internal

    func configure(episode: EpisodeViewModel) {
        self.imageView?.image = UIImage(systemName: "video")

        self.textLabel?.text = episode.title
        self.textLabel?.font = .preferredFont(forTextStyle: .headline)
        self.textLabel?.textColor = .label

        self.detailTextLabel?.text = episode.durationText
        self.detailTextLabel?.font = .preferredFont(forTextStyle: .footnote)
        self.detailTextLabel?.textColor = .secondaryLabel

        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
}
