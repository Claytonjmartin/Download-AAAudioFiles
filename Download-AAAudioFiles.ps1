Function Download-AAAudioFiles {
        <#
    Description:
        This function will download previously uploaded audio files from the specified Microsoft Teams Auto Attendant to the specified folder on the local machine.
    Parameters:
        -Identitiy
        -OutputFolder
    Example:
        Download-AAAudioFiles -Identitiy "6f45e634-0e8d-4f00-8f32-d8d4ca18dcfa" -OutputFolder "C:\Users\adm\Downloads\queue1"
    Author:
        Clayton Martin
    Source: 
        https://github.com/Claytonjmartin/Download-AAAudioFiles
    Disclamer: 
        This script is provided "As Is" without any warranty of any kind. In no event shall the author be liable for any damages arising from the use of this script.
    #>param(
        [Parameter(Mandatory = $true)]$Identity,
        [Parameter(Mandatory = $true)]$OutputFolder
    )
    if(($OutputFolder[($OutputFolder.Length -1)]) -like "\"){
        $OutputFolder = $OutputFolder -replace ".$"
    }
    $AA = Get-CsAutoAttendant -Identity $Identity
    if ($aa.DefaultCallFlow.Greetings.audiofileprompt.DownloadUri) {
        Invoke-WebRequest -Uri $aa.DefaultCallFlow.Greetings.audiofileprompt.DownloadUri -OutFile ($OutputFolder + "\" + $AA.Name + " Greeting.wav") 
    }
    if ($aa.DefaultCallFlow.Menu.Prompts.audiofileprompt.DownloadUri) {
        Invoke-WebRequest -Uri $aa.DefaultCallFlow.Menu.Prompts.audiofileprompt.DownloadUri -OutFile ($OutputFolder + "\" + $AA.Name + " Prompts.wav") 
    }
    foreach ($callflow in $aa.CallFlows) {
        if ($callflow.Menu.Prompts.audiofileprompt.DownloadUri) {
            Invoke-WebRequest -Uri $callflow.Menu.Prompts.audiofileprompt.DownloadUri -OutFile ($OutputFolder + "\" + $AA.Name + $callflow.Name + " Prompts.wav")
        }
        if ($callflow.Greetings.audiofileprompt.DownloadUri) {
            Invoke-WebRequest -Uri $callflow.Greetings.audiofileprompt.DownloadUri -OutFile ($OutputFolder + "\" + $AA.Name + $callflow.Name + " Greeting.wav")
        }
    }
}