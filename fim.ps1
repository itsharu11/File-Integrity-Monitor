

Write-Host "What woould you like to do ?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin Monitoring files with save Baseline?"

$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

Function Calculate-File-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists(){
    $baelineExists = Test-Path -Path .\baseline.txt

    if($baelineExists)    {
        Remove-Item -Path .\baseline.txt
    }
}

if ($response -eq "A".ToUpper()){
    #Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists
    
    # Calculate Gasg from the target files and sotre in baseline.txt
    
    # Collect all  files in the target folder

    $files = Get-ChildItem -Path .\Files

    #for each file, calculate the hash, and write to baseline.txt
    foreach($f in $files){
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File ./baseline.txt -Append
    }
}

elseif ($response -eq "B".ToUpper()) {
    
    $fileHashDictionary = @{}
    
    # Load file | hash from baseline.txt and store them in a dictionary
    
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    foreach($f in $filePathsAndHashes) {
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
        #the data is divided into key and value pair the key is file path and hash is value
    }
    
    
    $fileHashDictionary
   

    
    #Begin (contiuously) monitoring files with saved Baseline
    while($true){
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files

        #for each file, calculate the hash, and write to baseline.txt
        foreach($f in $files){
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File ./baseline.txt -Append

            #notify if a new file has been created
             if ($fileHashDictionary[$hash.Path] -eq $null) {
                # A new file created
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
             }else{

                #notify if a new file has been created
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    #The file has not changed
                }
                else {
                    Write-Host "$($hash.Path) has Changed!!!" -ForegroundColor Yellow
                }
            }
            

        }
        foreach($key in $fileHashDictionary.keys){
                $baselineFileStillExists = Test-Path -Path $key
                if(-Not $baselineFileStillExists) {
                    #one of the file has been deleted
                    Write-Host "$($key) has been deleted" -ForegroundColor Red
                }
            }
    }
}