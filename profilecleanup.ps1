# powershell -noexit -ExecutionPolicy Bypass -File profilecleanup.ps1
# bypass policy

# Define the array of account names
$accountNames = @('UserA', 'UserB', 'UserC')

# Loop through each account name and execute the command
foreach ($accountName in $accountNames) {
    Write-Output "Processing account: $accountName"
    
    # Fetch the user profile
    $profile = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $accountName }
    
    if ($profile) {
        Write-Output "Profile found for account: $accountName"
        
        # Get the user folder path
        $userFolderPath = $profile.LocalPath
        
        # Check if the user folder exists
        if (Test-Path -Path $userFolderPath) {
            Write-Output "User folder found for account: $accountName"
            
            # Display the command that will be executed
            Write-Output "Removing user folder for account: $accountName"
            Write-Output "Command: Remove-Item -Path $userFolderPath -Recurse -Force"
            
            # Execute the command to remove the user folder
            Remove-Item -Path $userFolderPath -Recurse -Force
            Write-Output "User folder removed for account: $accountName"
        } else {
            Write-Output "User folder for account: $accountName not found."
        }
        
        # Display the command that will be executed
        Write-Output "Removing profile for account: $accountName"
        Write-Output "Command: Remove-CimInstance -InputObject \$profile"
        
        # Execute the command to remove the profile
        $profile | Remove-CimInstance
        Write-Output "Profile removed for account: $accountName"
        
    } else {
        Write-Output "Profile for account: $accountName not found."
    }
    
    Write-Output "Finished processing account: $accountName"
    Write-Output "----------------------------------------"
}
