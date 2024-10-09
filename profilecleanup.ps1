# Define the array of account names
$accountNames = @('UserA', 'UserB', 'UserC')

# Loop through each account name and execute the command
foreach ($accountName in $accountNames) {
    Write-Output "Processing account: $accountName"
    
    # Fetch the user profile
    $profile = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $accountName }
    
    if ($profile) {
        Write-Output "Profile found for account: $accountName"
        
        # Display the command that will be executed
        Write-Output "Removing profile for account: $accountName"
        Write-Output "Command: Remove-CimInstance -InputObject \$profile"
        
        # Execute the command to remove the profile
        $profile | Remove-CimInstance
        Write-Output "Profile removed for account: $accountName"
        
        # Remove the user's folder
        $userFolder = $profile.LocalPath
        if (Test-Path $userFolder) {
            Write-Output "Removing user folder: $userFolder"
            
            # Remove subfolders and files
            Get-ChildItem -Path $userFolder -Recurse | ForEach-Object {
                Write-Output "Removing: $_"
                Remove-Item -Path $_.FullName -Recurse -Force
            }
            
            # Remove the main user folder
            Remove-Item -Path $userFolder -Recurse -Force
            Write-Output "User folder removed: $userFolder"
        } else {
            Write-Output "User folder not found: $userFolder"
        }
    } else {
        Write-Output "Profile for account: $accountName not found."
    }
    
    Write-Output "Finished processing account: $accountName"
    Write-Output "----------------------------------------"
}
