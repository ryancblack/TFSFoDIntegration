
<#
    Script: FoDSubmission.ps1
    Author: Ryan Black, ryan.black@hpe.com
    Version: 1.1
#>

[CmdletBinding()]
param(

[string]$source= $(throw "-source is required, e.g. ,$(TF_BUILD_BUILDDIRECTORY)"),

[string]$destination='C:\Windows\Temp',

[string]$applicationURL = $(throw "-applicationURL is required"),

[string]$username= $(throw '-username UserName is required.'),

[string]$password= $(throw '-password yourpassword is required.'),

[switch]$ExpressScan=$False,

[switch]$AutomatedAudit=$False,

[switch]$SonatypeReport=$False,

[string]$zipName='fod.zip'

)


$fullzippath = [io.path]::combine($destination, $zipName)

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

$scriptpath = Get-ScriptDirectory
$fulluploaderpath = [io.path]::combine($scriptpath, 'FoDUpload.jar')

# Delete existing ZIP, if needed


If(Test-path $fullzippath) {

Remove-item $fullzippath

[console]::WriteLine("Deleted existing submission ZIP: {0}", $fullzippath)


}

# Create the ZIP

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($Source, $fullzippath)


Write-Host "Created submission ZIP: $fullzippath"


Write-Host "Application URL: $applicationURL"


# Prepare the argument string for FodUpload.jar

$sb = New-Object -TypeName "System.Text.StringBuilder";

[void]$sb.Append($username + " ")
[void]$sb.Append($password + " ")
[void]$sb.Append("""" + $applicationURL + """ ")
[void]$sb.Append("""" + $fullzippath + """")

if($ExpressScan) {

[void]$sb.Append(' -scanPreferenceId:2 ')
}
if($AutomatedAudit){
[void]$sb.Append('-auditPreferenceId:2 ')
}
if($SonatypeReport){
[void]$sb.Append('-runSonatypeScan:true')
}

[string] $uploaderCommand = $sb.ToString()


$javaCommand = "-jar " + """" + $fulluploaderpath + """" + " " + $uploaderCommand


# Call the FoDUpload.jar app with the required parameters

$ps = New-Object System.Diagnostics.Process

$ps.StartInfo.FileName = "java"
$ps.Startinfo.Arguments = $javaCommand


$ps.StartInfo.RedirectStandardOutput = $True
$ps.StartInfo.UseShellExecute = $False


$ps.Start()

$ps.WaitForExit()

[string] $Out = $ps.StandardOutput.ReadToEnd();


## Write-Host $Out

###########################
# uncomment for debugging #
###########################

# Write-Host $javaCommand

