//
//  MascotAsset.swift
//  SnapWake
//
//  Created by Claude on 20/03/2026.
//

import SwiftUI

/// Système centralisé pour gérer les assets mascottes
enum MascotAsset: String, CaseIterable {
    case base = "mascot_base"
    case bienvenue = "mascot_bienvenue"
    case guide = "mascot_guide"
    case challenge = "mascot_challenge"
    case victoire = "mascot_victoire"
    case encouragement = "mascot_encouragement"
    case triste = "mascot_triste"
    case alerte = "mascot_alerte"

    /// Description de l'usage recommandé de chaque pose
    var usage: String {
        switch self {
        case .base:
            return "État neutre / défaut"
        case .bienvenue:
            return "Écran de bienvenue / salut"
        case .guide:
            return "Explication / guide / tutoriel"
        case .challenge:
            return "Défi / mission / avant challenge"
        case .victoire:
            return "Succès / achievement / objectif atteint"
        case .encouragement:
            return "Progression / streak / continuité / encouragement"
        case .triste:
            return "Échec / rechute / retour après absence"
        case .alerte:
            return "Alarme active / wake challenge en cours"
        }
    }

    /// Retourne l'image SwiftUI
    var image: Image {
        Image(self.rawValue)
    }
}

/// Extension pour faciliter l'utilisation des mascottes
extension Image {
    /// Créer une image mascotte à partir d'un asset
    static func mascot(_ asset: MascotAsset) -> Image {
        asset.image
    }
}
