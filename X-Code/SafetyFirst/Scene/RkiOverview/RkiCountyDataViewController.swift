//
//  RkiCountyDataViewController.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 10.11.20.
//

import UIKit

class RkiCountyDataViewController: UIViewController {

    var rkiCountyDataController = RkiCountyDataController()

    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var rulesTitleLabel: UILabel!
    @IBOutlet private var maskTitleLabel: UILabel!
    @IBOutlet private var maskDescriptionTxt: UILabel!
    @IBOutlet private var partyTitleLabel: UILabel!
    @IBOutlet private var partyDescriptionTxt: UILabel!
    @IBOutlet private var timeTitleLabel: UILabel!
    @IBOutlet private var timeDescriptionTxt: UILabel!
    @IBOutlet var cases7Label: UILabel!
    @IBOutlet var phaseView: UIView!
    @IBOutlet var maskContainerView: UIView!
    @IBOutlet var partyContainerView: UIView!
    @IBOutlet var timeContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        rkiCountyDataController.didReceiveState = handleState
        rkiCountyDataController.getRkiData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        setupView()
    }

    // MARK: - methodes

    // view setup
    private func setupView() {
        phaseView.layer.cornerRadius = 75
        phaseView.layer.borderWidth = 2
        phaseView.layer.borderColor = UIColor.systemGray2.cgColor
        maskContainerView.layer.cornerRadius = 15
        maskContainerView.layer.borderWidth = 2
        maskContainerView.layer.borderColor = UIColor.systemGray2.cgColor
        partyContainerView.layer.cornerRadius = 15
        partyContainerView.layer.borderWidth = 2
        partyContainerView.layer.borderColor = UIColor.systemGray2.cgColor
        timeContainerView.layer.cornerRadius = 15
        timeContainerView.layer.borderWidth = 2
        timeContainerView.layer.borderColor = UIColor.systemGray2.cgColor
    }

    // state handling
    private func handleState(_ state: RkiCountyDataState) {
        switch state {
            case .idle:
                hideLoadingIndicator()

            case .loading:
                showLoadingIndicator()

            case .failed(let error):
                hideLoadingIndicator()
                handleError(error)

            case .success(let phase):
                handlePhase(phase: phase)
        }
    }

    // phase handling
    private func handlePhase(phase: RkiCountyDataPhase) {
        isContentVisible(false)
        rulesTitleLabel.text = NSLocalizedString("label_title_rules", comment: "this rules apply")
        maskTitleLabel.text = NSLocalizedString("label_title_mask", comment: "masks are mandatory")
        partyTitleLabel.text = NSLocalizedString("label_title_party", comment: "partys and contact")
        timeTitleLabel.text = NSLocalizedString("label_title_time", comment: "time limit")

        switch phase {
            case .phase1(let attributes):
                hideLoadingIndicator()

                DispatchQueue.main.async {
                    self.cases7Label.text = String(format: "%.2f", attributes.cases7PerOnehundretK) + "*"
                    self.phaseView.backgroundColor = UIColor(named: "customGreen")
                    self.descriptionLabel.text = String(format: NSLocalizedString("label_title_casesForCounty%@", comment: "*cases per..."), attributes.county)
                    self.maskDescriptionTxt.text = NSLocalizedString("label_txt_mask_phase1", comment: "mask rules")
                    self.partyDescriptionTxt.text = NSLocalizedString("label_txt_party_phase1", comment: "party rules")
                    self.timeContainerView.isHidden = true
                }
            case .phase2(let attributes):
                hideLoadingIndicator()

                DispatchQueue.main.async {
                    self.cases7Label.text = String(format: "%.2f", attributes.cases7PerOnehundretK) + "*"
                    self.phaseView.backgroundColor = UIColor(named: "customYellow")
                    self.descriptionLabel.text = String(format: NSLocalizedString("label_title_casesForCounty%@", comment: "*cases per..."), attributes.county)
                    self.maskDescriptionTxt.text = NSLocalizedString("label_txt_mask_phase2", comment: "mask rules")
                    self.partyDescriptionTxt.text = NSLocalizedString("label_txt_party_phase2", comment: "party rules")
                    self.timeDescriptionTxt.text = NSLocalizedString("label_txt_time_phase2", comment: "time rules")
                }
            case .phase3(let attributes):
                hideLoadingIndicator()

                DispatchQueue.main.async {
                    self.cases7Label.text = String(format: "%.2f", attributes.cases7PerOnehundretK) + "*"
                    self.phaseView.backgroundColor = UIColor(named: "customRed")
                    self.descriptionLabel.text = String(format: NSLocalizedString("label_title_casesForCounty%@", comment: "*cases per..."), attributes.county)
                    self.maskDescriptionTxt.text = NSLocalizedString("label_txt_mask_phase3", comment: "mask rules")
                    self.partyDescriptionTxt.text = NSLocalizedString("label_txt_party_phase3", comment: "party rules")
                    self.timeDescriptionTxt.text = NSLocalizedString("label_txt_time_phase3", comment: "time rules")
                }

            case .phase4(let attributes):
                hideLoadingIndicator()

                DispatchQueue.main.async {
                    self.cases7Label.text = String(format: "%.2f", attributes.cases7PerOnehundretK) + "*"
                    self.phaseView.backgroundColor = UIColor(named: "customDarkRed")
                    self.descriptionLabel.text = String(format: NSLocalizedString("label_title_casesForCounty%@", comment: "*cases per..."), attributes.county)
                    self.maskDescriptionTxt.text = NSLocalizedString("label_txt_mask_phase4", comment: "mask rules")
                    self.partyDescriptionTxt.text = NSLocalizedString("label_txt_party_phase4", comment: "party rules")
                    self.timeDescriptionTxt.text = NSLocalizedString("label_txt_time_phase4", comment: "time rules")
                }
        }
    }

    // handle your error handling
    private func handleError(_ rkiCountyDataError: RkiCountyDataError) {
            self.isContentVisible(true)
            self.rulesTitleLabel.text = NSLocalizedString("title_sorry", comment: "excuse me...")

        switch rkiCountyDataError {
            case .networkError(message: let message):
                DispatchQueue.main.async {
                    self.showAlert(with: NSLocalizedString("title_error", comment: "Error"), message: message)
                }
            case .federalStateError(message: let message):
                DispatchQueue.main.async {
                    self.showAlert(with: NSLocalizedString("title_note", comment: "Note"), message: message)
                }
            case .unknownLoactionError(message: let message):
                DispatchQueue.main.async {
                    self.showAlert(with: NSLocalizedString("title_error", comment: "Error"), message: message)
                }
            case .locationDeniedError(message: let message):
                DispatchQueue.main.async {
                    self.showAlert(with: NSLocalizedString("title_note", comment: "Note"), message: message)
                }
        }
    }

    private func isContentVisible(_ bool: Bool) {
        phaseView.isHidden = bool
        maskContainerView.isHidden = bool
        partyContainerView.isHidden = bool
        timeContainerView.isHidden = bool
        descriptionLabel.isHidden = bool
    }

    // MARK: - IBActions
    @IBAction func refreshView(_ sender: Any) {
        rkiCountyDataController.getRkiData()
    }
}

