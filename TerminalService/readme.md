# Reset Terminal Server (RDS) Grace Period using PowerShell for 120 Days

We often need to deploy Terminal Server (Remote Desktop Session Host in 2012) for testing purposes in development environments allowing more than 2 concurrent Remote Desktop Sessions on it. When it is installed, by default it is in default Grace licensing period which is 120 days and it works fine.

Once Grace period expires, the server does not allow even a single Remote Desktop session via RDP and all we can do is logon to the Console of machine using Physical/Virtual console depending on Physical or Virtual machines or try to get in using mstsc /admin or mstsc /console, then remove the role completely and restart the terminal server and it starts accepting default two RDP sessions.

We sometimes find ourselves in situation when server is nearing to the end of grace period and we don’t have a TS Licensing server in place and we need the default grace period to be reset/extended to next 120 days.

I have created a Script which can be used to query the remaining days of grace period and extend/reset it to next 120 days in case needed.

