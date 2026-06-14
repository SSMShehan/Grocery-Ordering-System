$ErrorActionPreference = "Stop"

$mavendUrl = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$installDir = "$HOME\.gemini\tools"
$mavenHome = "$installDir\apache-maven-3.9.6"
$mavenBin = "$mavenHome\bin"

Write-Host "Checking for Maven..."

if (!(Test-Path "$mavenBin\mvn.cmd")) {
    Write-Host "Maven not found. Downloading portable Maven..."
    if (!(Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    $zipPath = "$installDir\maven.zip"
    Invoke-WebRequest -Uri $mavendUrl -OutFile $zipPath
    
    Write-Host "Extracting Maven..."
    Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
    Remove-Item $zipPath
}
else {
    Write-Host "Maven found at $mavenHome"
}

$env:JAVA_HOME = "C:\Program Files\Java\jdk-25.0.2"
$env:PATH = "$mavenBin;$env:JAVA_HOME\bin;$env:PATH"

Write-Host "Cleaning and Building Project..."
mvn clean install -DskipTests

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build Successful. Starting Server..."
    Write-Host "Create a new terminal to check the website if this hangs."
    Write-Host "Access the app at: http://localhost:8081/grocery"
    mvn jetty:run
}
else {
    Write-Host "Build Failed."
}
