# Timer Futuriste (iOS 16.1+)

Application iOS SwiftUI de minuteur + chronometre, avec UI claire futuriste, notifications locales et Live Activity/Dynamic Island (iOS 16.1+).

## Fonctionnalites V1

- Minuteur: presets 1/5/10/25 min, duree personnalisee, pause/reprise/reset.
- Chronometre: start/pause/reprise/reset + tours.
- Background: notification locale a la fin du minuteur.
- Live Activity: affichage lock screen + Dynamic Island (appareils compatibles).

## Structure

- `project.yml`: spec XcodeGen (genere `TimerFuturiste.xcodeproj`)
- `Sources/TimerFuturiste`: app principale (MVVM, services, UI)
- `Sources/TimerFuturisteLiveActivityExtension`: extension WidgetKit pour Live Activity
- `Shared/LiveActivity`: attributs ActivityKit partages
- `Tests/TimerFuturisteTests`: tests unitaires
- `Tests/TimerFuturisteUITests`: tests UI
- `.github/workflows/ios-ipa.yml`: pipeline CI macOS pour generer un `.ipa`

## Build local (Mac)

```bash
brew install xcodegen
xcodegen generate
open TimerFuturiste.xcodeproj
```

## Build IPA via CI (depuis Windows, 100% gratuit)

Le workflow `Build iOS IPA` produit un `.ipa` **non signe** sur runner macOS GitHub, sans certificat Apple ni provisioning profile.

1. Aller dans l'onglet `Actions` du repo GitHub.
2. Lancer le workflow `Build iOS IPA` (`Run workflow`).
3. Recuperer l'artefact `TimerFuturiste-unsigned-ipa`.

## Installation avec AltStore

1. Telecharger `TimerFuturiste-unsigned.ipa` depuis les artifacts du run.
2. Ouvrir AltStore sur iPhone (meme Apple ID gratuit que AltServer).
3. Importer le `.ipa` dans AltStore, qui resignera l'app automatiquement.
4. Rafraichir l'app avant l'expiration (~7 jours en compte gratuit).
