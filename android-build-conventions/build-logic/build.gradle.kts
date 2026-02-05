plugins {
    `kotlin-dsl`
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    compileOnly("com.android.tools.build:gradle:8.3.2") // match your AGP
    compileOnly(kotlin("gradle-plugin"))
}
