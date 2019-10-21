
# Connect Azure AD
Connect-AzureAD

# Connect to Azure AD specific tenant id
Connect-AzureAD -TenantId elven.onmicrosoft.com

### PART 1 : INVITE SYNTAX ###

# Simple: Invite B2B User

New-AzureADMSInvitation -InvitedUserDisplayName "Name (Company)" -InvitedUserEmailAddress "alias@domain.com" `
    -InviteRedirectUrl "https://myapps.microsoft.com" -SendInvitationMessage $true

# Advanced: Invite B2B User
# https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureadmsinvitation?view=azureadps-2.0

$invitedUserUpn = "jan.vidar.elven@skill.no"
$invitedUserDisplayName = "Jan Vidar Elven (Skill)"
$inviteRedirectUrl = "https://myapps.microsoft.com"

$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = "Hi! You are invited to Azure AD as a Guest with PowerShell!"
$messageInfo.MessageLanguage = "en-US"
$recipient = New-Object Microsoft.Open.MSGraph.Model.Recipient
$emailAddress = New-Object Microsoft.Open.MSGraph.Model.EmailAddress
$emailAddress.Name = "Jan Vidar Elven"
$emailAddress.Address = "jan.vidar@elven.no"
$recipient.EmailAddress = $emailAddress
$messageInfo.CcRecipients = $recipient

$inviteRespons = New-AzureADMSInvitation -InvitedUserDisplayName $invitedUserDisplayName -InvitedUserEmailAddress $invitedUserUpn `
    -InviteRedirectUrl $inviteRedirectUrl -InvitedUserMessageInfo $messageInfo `
    -SendInvitationMessage $true -InvitedUserType "Guest"

# Look at Invite Response
$inviteRespons | Select-Object InviteRedeemUrl, Status

$aadUser = Get-AzureADUser -All $true -Filter "UserType eq 'Guest' and startswith(displayName,'Jan Vidar')" | ConvertTo-Json

