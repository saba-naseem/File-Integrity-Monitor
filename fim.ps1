# Function that returns the hash value of the file
Function Calculate-File-Hash($filepath)
{
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

# Function to Delete the Baseline file if it already exists
Function Erase-Baseline-If-Already-Exists()
{
     $baselineExists = Test-Path -Path .\baseline.txt

     if ($baselineExists)
     {
         # Delete it
         Remove-Item -Path .\baseline.txt
     }
}

# Function to Collect all files in the target folder
Function Collect-all-files()
{
     $files = Get-ChildItem -Path .\Files
     return $files
}

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "     A) Collect new Baseline?"
Write-Host "     B) Begin monitoring files with saved Baseline?"
Write-Host ""

# Get the reponse from the user
$response = Read-Host -Prompt "Please Enter 'A' or 'B'"
Write-Host ""

# If the reponse is "A", then performing the below if loop, inorder to collect new Baseline
if ($response -eq "A".ToUpper())
{  
     # Delete baseline.txt if it already exists
     Erase-Baseline-If-Already-Exists

     # Calculate Hash from the target files and store in baseline.txt
     # Collect all files in the target folder
     $files = Collect-all-files
     
     # For each file, calculate the hash, and write to baseline.txt
     foreach ($f in $files) 
     {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }
}

# If the reponse is "B", then performing the below elseif loop, inorder to Begin monitoring files with saved Baseline
elseif ($response -eq "B".ToUpper()) {
    
    # Creating a Dictionary
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    
    # Storing each file path as key and hash as value from the baseline.txt into the Dictionary
    foreach ($f in $filePathsAndHashes) 
    {
         $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }

    # Begin (continuously) monitoring files with saved Baseline
    while ($true) 
    {
        # Wait for another second before again checking for integrity of the file 
        Start-Sleep -Seconds 1
        
        # Collect all files in the target folder
        $files = Collect-all-files

        # For each file, calculate the hash, and notify if a new file has been created or if file has been changed
        foreach ($f in $files)
        {
            $hash = Calculate-File-Hash $f.FullName

            # Notify if a new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null)
            {
                # A new file has been created!
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else
            {
                # Notify if a new file has been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash)
                {
                    # The file has not changed
                }
                else
                {
                    # Notify if file has been compromised
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

        # Notify if a file has been deleted
        foreach ($key in $fileHashDictionary.Keys)
        {
            # Check if the file exists
            $baselineFileStillExists = Test-Path -Path $key

            if (-Not $baselineFileStillExists)
            {
                # One of the baseline files must have been deleted, notify the user
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
}
