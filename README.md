# 🤖 Android Reusable CI/CD Workflows (Jetpack Compose)

A production-ready reusable **GitHub Actions CI/CD pipeline for Android applications**, supporting automated testing, JaCoCo coverage enforcement, APK/AAB builds, secure signing, Google Play deployment, Esper deployment, and GitHub release management.

---

## ✨ Features

- Gradle build caching
- Detekt static analysis (auto-detected)
- Android unit tests
- JaCoCo coverage reporting
- Coverage threshold enforcement
- APK & AAB build
- Secure keystore signing
- Google Play Store deployment
- Esper device deployment
- GitHub Release creation
- Automatic semantic version conflict resolution
- Optional **“What’s New”** release notes from file
- CI coverage summary inside GitHub Actions

---

# 📦 Repository Structure

```
.github/workflows
├── push.yml        # Reusable Android CI workflow
└── release.yml     # Reusable Android CD workflow
```

---

# 🧠 Architecture Overview

Caller App Repository triggers reusable workflows.

### Reusable CI Workflow (`push.yml`)

```
Checkout repository
      ↓
Setup JDK
      ↓
Gradle dependency cache
      ↓
Run Detekt (if present)
      ↓
Run unit tests
      ↓
Generate JaCoCo coverage report
      ↓
Coverage threshold check
      ↓
Build APK/AAB
      ↓
Upload artifacts and reports
```

### Reusable CD Workflow (`release.yml`)

```
Run CI workflow
        ↓
Create GitHub Release
        ↓
Download unsigned build artifacts
        ↓
Sign APK/AAB
        ↓
Deploy to Play Store (optional)
        ↓
Deploy to Esper (optional)
        ↓
Upload signed artifacts to GitHub Release
```

---

# 🧪 Reusable CI Workflow (`push.yml`)

Handles:

- JDK setup
- Gradle dependency caching
- Static analysis using Detekt (if available)
- Android unit tests
- JaCoCo coverage generation
- Coverage threshold validation
- APK/AAB build
- Artifact uploads

---

## Inputs

| Input | Description |
|------|-------------|
| `java_version` | Java version for Gradle |
| `build_variant` | Android build variant (Debug / Release / StagingDebug) |
| `coverage_threshold` | Minimum coverage percentage required |

---

## Outputs

| Output | Description |
|------|-------------|
| `coverage_percent` | Computed JaCoCo LINE coverage percent |

---

# 📊 Coverage Gate

The CI pipeline automatically:

1. Generates a **JaCoCo XML report**
2. Extracts **LINE coverage**
3. Compares it against the configured threshold

Example:

```
Threshold: 75%
Actual Coverage: 78.43%

Result: PASSED
```

If coverage is below the threshold, the pipeline **fails automatically**.

---

# 🚀 Reusable CD Workflow (`release.yml`)

Handles:

- CI execution
- GitHub Release creation
- APK/AAB signing
- Google Play Store deployment
- Esper deployment
- Artifact upload to GitHub Release
- Optional release notes support

---

## Inputs

| Input | Description |
|------|-------------|
| `version` | Base semantic version |
| `java_version` | Java version |
| `build_variant` | Android build variant |
| `coverage_threshold` | Coverage requirement |
| `deploy_to_playstore` | Enable Play Store deployment |
| `playstore_track` | Play Store track (internal/beta/production) |
| `playstore_status` | Release status |
| `package_name` | Android package name |
| `deploy_to_esper` | Enable Esper deployment |
| `esper_org_id` | Esper organization ID |
| `esper_app_id` | Esper application ID |
| `enable_whats_new` | Enable release notes |
| `whats_new_file` | File containing release notes |

---

# 📝 “What’s New” (Release Notes from File)

Create a file inside your app repository:

```
release_notes.txt
```

Example content:

```
- Added onboarding screen
- Improved login performance
- Fixed crash on Android 14
```

Enable it in the caller workflow:

```yaml
enable_whats_new: true
whats_new_file: release_notes.txt
```

The same release notes are used for:

- **Google Play Store release notes**
- **GitHub Release notes**

---

# 📲 Android Support

- Gradle builds
- Detekt static analysis
- Unit tests
- JaCoCo coverage reporting
- APK build
- AAB build
- Keystore signing
- Google Play Store deployment
- Esper device management deployment
- Artifact uploads
- GitHub Release integration

---

# 🔐 Required Secrets

## Android Signing

- `ANDROID_KEYSTORE`
- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`

---

## Google Play Store

- `PLAYSTORE_SERVICE_ACCOUNT`

---

## Esper Deployment

- `ESPER_API_KEY`

---

# 🧩 Example Caller Workflow Usage

```yaml
call-android-release:
  uses: your-org/android-reusable/.github/workflows/release.yml@main

  with:
    version: 1.2.0
    java_version: 17
    build_variant: Release
    coverage_threshold: "75.00"

    deploy_to_playstore: true
    playstore_track: internal
    playstore_status: completed
    package_name: com.example.app

    deploy_to_esper: false

    enable_whats_new: true
    whats_new_file: release_notes.txt

  secrets:
    ANDROID_KEYSTORE: ${{ secrets.ANDROID_KEYSTORE }}
    KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
    KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
    KEY_ALIAS: ${{ secrets.KEY_ALIAS }}

    PLAYSTORE_SERVICE_ACCOUNT: ${{ secrets.PLAYSTORE_SERVICE_ACCOUNT }}

    ESPER_API_KEY: ${{ secrets.ESPER_API_KEY }}
```

---

# 📁 Example App Repository Layout

```
your-android-app
├── app
├── gradle
├── gradlew
├── release_notes.txt
└── .github/workflows
    └── main.yml
```

---

# 🏗️ Design Principles

- Fully reusable workflows
- Secure secret handling
- Modular CI/CD architecture
- CI and CD separation
- Store-ready deployments
- Coverage-enforced testing
- Optional deployments
- No secrets stored in repository

---

# 🧭 Roadmap

Planned improvements:

- Firebase App Distribution
- Slack notifications
- PR preview builds
- Play Store staged rollout
- Multi-language release notes
- Android Lint reporting
- Code coverage badges

---

# 🤝 Contributing

Pull requests are welcome for:

- Bug fixes
- CI performance improvements
- New integrations
- Documentation improvements

---

# 📜 License

MIT License

---

# ⭐ Why use this?

Because it is:

- Fully automated
- Secure
- Reusable across Android projects
- Coverage-aware
- Play Store ready
- Enterprise-ready
- GitHub Release integrated

---

# 👨‍💻 Author

Reusable **Android CI/CD Pipeline for GitHub Actions**

---

# 🎯 One-command releases

Trigger the release workflow and automatically:

- Run tests
- Validate coverage
- Build APK/AAB
- Sign artifacts
- Deploy to Play Store
- Deploy to Esper
- Create GitHub Release

Ship Android apps faster 🚀
