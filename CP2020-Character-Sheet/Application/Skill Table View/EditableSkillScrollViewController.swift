//
//  EditableSkillScrollViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/13/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditableSkillScrollViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let viewModel = EditableSkillScrollViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])

        // Do any additional setup after loading the view.
    }
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    private func uneditableHeaderLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.headerText
        
        return label
    }
    
    private func uneditableDescriptionLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.descriptionText
        
        return label
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private struct EditableSkillScrollViewModel: MarginCreator {
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let blueColor = StyleConstants.Color.blue
    let redColor = StyleConstants.Color.red
    
    let headerText = StyleConstants.Font.defaultBold
    let descriptionText = StyleConstants.Font.light
    let editableText = StyleConstants.Font.defaultFont
    
    let headerRowHeight: CGFloat = 32
    let descriptionRowHeight: CGFloat = 32
    let editableSingleLineRowHeight: CGFloat = 44
}

/// The modes for editing a skill
///
/// - new: Creating a brand new skill
/// - existing: Editing an existing skill (simple)
/// - existingWithExtension: Editing an existing skill that may already be in the list without an extension
///                          (i.e. Changing 'Expert' to 'Expert: Particle Physics'
enum EditingSkilMode {
    case new, existing, existingWithExtension
}

/// Strings used in the skill editor view
private struct SkillStrings {
    static let skill = "Skill"
    
    static let skillName = "Name"
    static let skillNameHelpText = "The name of the skill."
    
    static let skillNameExtension = "Optional Extension"
    static let skillNameExtensionHelpText = "Optional extension to the skill name (i.e. the 'English' in 'Language: English'"
    
    static let associatedStat = "Associated Stat"
    static let associatedStatHelpText = "The player stat associated with this skill. The points in the stat are added to the total points for the skill."
    
    static let pointsAssigned = "Points Assigned By Player"
    static let modifierPoints = "Modifier Points"
    static let totalPoints = "Total Points"
    
    static let improvementPoints = "Improvement Points"
    static let improvementPointsHelpText = "The IP accrued for usage of this skill."
    
    static let IPMultiplier = "IP Multiplier"
    static let IPMultiplierHelpText = "An additional multiplier to the number of IP required to increase the number of skill points."

    static let description = "Description"
    static let descriptionHelpText = "Describes the valid usage of the skill."
    
    static let favorite = "Highlighted Skill"
    static let hideSkill = "Hide Skill"
}
