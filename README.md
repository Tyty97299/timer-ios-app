# Timer Futuriste (iOS 17+)

Application iOS SwiftUI de minuteur + chronometre, avec UI claire futuriste, notifications locales et Live Activity/Dynamic Island.

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

## Build IPA via CI (depuis Windows)

Configurer les secrets GitHub:

- `APPLE_P12_BASE64`: certificat signing exporte en base64 (`.p12`)
- `APPLE_P12_PASSWORD`: mot de passe du `.p12`
- `APPLE_PROFILE_BASE64`: provisioning profile en base64 (`.mobileprovision`)
- `APPLE_TEAM_ID`: Team ID Apple Developer

Ensuite lancer le workflow `Build iOS IPA` dans GitHub Actions. L'artefact `.ipa` sera telechargeable depuis le run.

## Installation avec AltStore

1. Telecharger l'artefact `.ipa` du workflow.
2. Ouvrir AltStore sur iPhone.
3. Importer le `.ipa`.
4. Verifier les permissions notifications au premier lancement.

