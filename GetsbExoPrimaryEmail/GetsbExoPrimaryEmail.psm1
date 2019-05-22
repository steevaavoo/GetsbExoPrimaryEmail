function Get-sbExoPrimaryEmail {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$Identity = '*'
    )

    BEGIN { }

    PROCESS {
        # Getting all email mailboxes into a variable for quick access
        try {
            $mailboxes = Get-Mailbox -Identity $Identity -ErrorAction SilentlyContinue
        } catch {
            throw 'Please connect to Exchange Online using Connect-ExopsSession prior to running this command.'
        }
        foreach ($mailbox in $mailboxes) {
            $emailaddresses = $mailbox.EmailAddresses
            foreach ($emailaddress in $emailaddresses) {
                $smtpaddress = $emailaddress | Where-Object { $_ -clike '*SMTP*' }
            if ($smtpaddress) {
                # Moving this outside the foreach emailaddress loop returns different results for some reason
                [PSCustomObject]@{
                    'Name'        = $mailbox.Name
                    'SMTPAddress' = $smtpaddress
                }
            } else {
                # do nothing if no SMTP address
            } #if smtpaddress exists
        } #foreach emailaddress
    } #foreach mailbox
} #process

END { }

} #function