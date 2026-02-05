import org.gradle.testing.jacoco.tasks.JacocoReport
import org.gradle.testing.jacoco.plugins.JacocoPluginExtension
import org.gradle.api.tasks.testing.Test
import java.math.RoundingMode

plugins {
    id("jacoco")
}

configure<JacocoPluginExtension> {
    toolVersion = "0.8.11"
}

val coverageVariant = (findProperty("coverageVariant") as String?) ?: "Debug"
val variantCap = coverageVariant.replaceFirstChar { it.uppercaseChar() }

tasks.withType<Test>().configureEach {
    // optional; keep if needed for Robolectric/JDK17
    jvmArgs("--add-opens=java.base/java.lang=ALL-UNNAMED")
}

fun FileTree.excludeCommonGenerated() = apply {
    exclude(
        "**/R.class",
        "**/R$*.class",
        "**/BuildConfig.*",
        "**/Manifest*.*",
        "**/*Test*.*",
        "android/**/*.*",

        // databinding / generated
        "**/databinding/**",
        "**/*Binding*.*",
        "**/BR.*",
        "**/androidx/databinding/**",
        "**/androidx/databinding/library/**",
        "**/*DataBinderMapper*.*",
        "**/*DataBindingTriggerClass*.*",
        "**/generated/callback/**",

        // common DI/generated (optional)
        "**/*_Factory*",
        "**/*_MembersInjector*",
        "**/*Hilt*.*",
        "**/*Dagger*.*",
        "**/*Module*.*",
        "**/*Component*.*"
    )
}

val reportTaskName = "jacoco${variantCap}UnitTestReport"
val unitTestTaskName = "test${variantCap}UnitTest"

tasks.register<JacocoReport>(reportTaskName) {
    group = "verification"
    description = "Generates JaCoCo coverage report for $coverageVariant unit tests."

    dependsOn(unitTestTaskName)

    reports {
        xml.required.set(true)
        html.required.set(true)
        csv.required.set(false)
    }

    val buildDirFile = layout.buildDirectory.get().asFile

    val kotlinTree = fileTree("$buildDirFile/tmp/kotlin-classes/${coverageVariant.lowercase()}").excludeCommonGenerated()
    val javaTree = fileTree("$buildDirFile/intermediates/javac/${coverageVariant.lowercase()}/classes").excludeCommonGenerated()

    classDirectories.setFrom(files(kotlinTree, javaTree))

    sourceDirectories.setFrom(
        files("src/main/java", "src/main/kotlin")
    )

    executionData.setFrom(
        fileTree(buildDirFile) {
            include(
                "jacoco/${unitTestTaskName}.exec",
                "outputs/unit_test_code_coverage/${coverageVariant.lowercase()}UnitTest/${unitTestTaskName}.exec"
            )
        }
    )

    // avoid failures when no tests ran
    onlyIf { executionData.files.any { it.exists() } }
}

/**
 * Optional: provide a stable task name used by CI: jacocoTestReport
 * It will generate coverage for the chosen variant.
 */
tasks.register("jacocoTestReport") {
    group = "verification"
    description = "Alias for $reportTaskName (variant=$coverageVariant)"
    dependsOn(reportTaskName)
}
