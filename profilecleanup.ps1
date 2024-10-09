# Define the users to exclude
$excludedUsers = @("Administrator", "Domain Users", "YourUser1", "YourUser2")

# Add system accounts to the exclusion list
$systemAccounts = @("SYSTEM", "LOCAL SERVICE", "NETWORK SERVICE", "DefaultAccount", "Guest")
$excludedUsers += $systemAccounts

# Get all user profiles
$userProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false }

foreach ($profile in $userProfiles) {
    $username = $profile.LocalPath.Split("\")[-1]

    if ($excludedUsers -notcontains $username) {
        # Remove user profile folder forcefully using Get-ChildItem
        Get-ChildItem -Path $profile.LocalPath -Recurse -Force | Remove-Item -Recurse -Force

        # Remove user SID
        $sid = $profile.SID
        Remove-WmiObject -Query "SELECT * FROM Win32_UserProfile WHERE SID='$sid'"
    }
}

# Remove user SIDs from registry
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profileSIDs = Get-ChildItem -Path $regPath

foreach ($sid in $profileSIDs) {
    $username = (Get-ItemProperty -Path "$regPath\$sid.PSChildName").ProfileImagePath.Split("\")[-1]

    if ($excludedUsers -notcontains $username) {
        Get-ChildItem -Path "$regPath\$sid.PSChildName" -Recurse -Force | Remove-Item -Recurse -Force
    }
}
