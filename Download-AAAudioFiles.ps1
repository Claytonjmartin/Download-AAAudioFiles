Function Download-AAAudioFiles {
    param(
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