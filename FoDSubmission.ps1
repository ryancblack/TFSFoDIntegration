
<#
    Script: FoDSubmission.ps1
    Author: Ryan Black, ryan.black@hpe.com
    Version: 1.1
#>

[CmdletBinding()]
param(

[string]$Source= $(throw "-Source is required, e.g. ,$(TF_BUILD_BUILDDIRECTORY)"),

[string]$Destination='C:\Windows\Temp',

[string]$UploadURL = $(throw "-UploadURL is required"),

[string]$Username= $(throw '-Username UserName is required.'),

[string]$Password= $(throw '-Password yourpassword is required.'),

[string]$ProxyURL,

[string]$ProxyUserName,

[string]$ProxyPassword,

[string]$NTworkstationName,

[string]$NTdomain,

[string]$zipName='fod.zip',

[switch]$ExpressScan=$False,

[switch]$AutomatedAudit=$False,

[switch]$SonatypeReport=$False

)


$fullZipPath = [io.path]::combine($Destination, $zipName)

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

$scriptPath = Get-ScriptDirectory
$fullUploaderPath = [io.path]::combine($scriptPath, 'FoDUpload.jar')

# Delete existing ZIP, if needed


If(Test-path $fullZipPath) {

Remove-item $fullZipPath

[console]::WriteLine("Deleted existing submission ZIP: {0}", $fullZipPath)


}

# Create the ZIP

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($Source, $fullZipPath)


Write-Host "Created submission ZIP: $fullZipPath"


Write-Host "Application URL: $UploadURL"


# Prepare the required argument string

$sb = New-Object -TypeName "System.Text.StringBuilder";

[void]$sb.Append($Username + " ")
[void]$sb.Append($Password + " ")
[void]$sb.Append("""" + $UploadURL + """ ")
[void]$sb.Append("""" + $fullZipPath + """ ")

# Append optional proxy settings

if ($ProxyURL){

[void]$sb.Append("proxyUrl """ + $ProxyURL + """ ")

if($ProxyUserName){

[void]$sb.Append("proxyUsername " + $ProxyUserName + " ")
}

if($ProxyPassword){

[void]$sb.Append("proxyPassword " + $ProxyPassword + " ")
}
if($NTworkstationName){

[void]$sb.Append("ntWorkstation " + $NTworkstationName + " ")
}
if($NTdomain){

[void]$sb.Append("ntDomain " + $NTdomain)
}

}

# Append optional scan preference settings

if($ExpressScan) {

[void]$sb.Append(' -scanPreferenceId:2 ')
}
if($AutomatedAudit){
[void]$sb.Append(' -auditPreferenceId:2 ')
}
if($SonatypeReport){
[void]$sb.Append(' -runSonatypeScan:true')
}

[string] $uploaderCommand = $sb.ToString()


$javaCommand = "-jar " + """" + $fullUploaderPath + """" + " " + $uploaderCommand


###########################
# uncomment for debugging #
###########################

#Write-Host $javaCommand


# Call the FoDUpload.jar app with the required parameters

$ps = New-Object System.Diagnostics.Process

$ps.StartInfo.FileName = "java"
$ps.Startinfo.Arguments = $javaCommand


$ps.StartInfo.RedirectStandardOutput = $True
$ps.StartInfo.UseShellExecute = $False


$ps.Start()

$ps.WaitForExit()

[string] $Out = $ps.StandardOutput.ReadToEnd();


Write-Host $Out




