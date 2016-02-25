## TFSFoDIntegration

This project aims to provide a simple example of Team Foundation Server integration with the HPE Fortify on Demand uploader tool available to customers.

The PowerShell script, located on the server with the upload tool, may be called via a Build Defintion with required parameters. Please review the included PDF for detailed instructions.



#### Example:


|    Argument                                               |    Purpose                                                                                                                                                             |
|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|    -Source                                                |    Designates the root directory of the build project                                                                                                                  |
|    -Username                                              |    Fortify on Demand portal User Name                                                                                                                                  |
|    -Password                                              |    Fortify on Demand portal Password                                                                                                                                   |
|    -UploadURL                                             | Upload URL from the Fortify on Demand portal                                                                                                                           |
|    -ProxyURL  (optional)                                  |    Internal proxy address                                                                                                                                              |
|    -ProxyUserName                                         |    Proxy username                                                                                                                                                      |
|    -ProxyPassword                                         |    Proxy password                                                                                                                                                      |
|    -NTworkstationName                                     |    NT workstation name                                                                                                                                                 |
|    -NTdomain                                              |    NT domain name                                                                                                                                                      |
|    -ExpressScan (optional)                                |    Express assessment that does a less thorough   security check of the application in a shorter period of time                                                        |
|    -AutomatedAudit (optional)                             |    Automatically audited assessment that replaces the   manual audit with automatic false positive suppression using Fortify Scan Analytics                            |
|    -SonatypeReport (optional)                             |    Sonatype scan to identify Open Source components   and provide information on known vulnerabilities, along with recommended   versions and licensing information    |
