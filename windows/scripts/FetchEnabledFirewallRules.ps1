# Get enabled firewall rules
$firewallRules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' }

# Separate the rules into inbound and outbound
$inboundRules = $firewallRules | Where-Object { $_.Direction -eq 'Inbound' }
$outboundRules = $firewallRules | Where-Object { $_.Direction -eq 'Outbound' }

# Create an HTML format
$htmlFormat = "<style>BODY{background-color:LightBlue;}</style>"

# Convert inbound and outbound firewall rules to HTML
$inboundRulesHTML = $inboundRules | Select-Object Name, DisplayName, Profile, Direction, Action, Enabled, LocalPort |
    ConvertTo-HTML -Head $htmlFormat -Body "<H2>Enabled Inbound Firewall Rules</H2>"
$outboundRulesHTML = $outboundRules | Select-Object Name, DisplayName, Profile, Direction, Action, Enabled, LocalPort |
    ConvertTo-HTML -Head $htmlFormat -Body "<H2>Enabled Outbound Firewall Rules</H2>"

# Save the HTML to a file
$combinedHTML = $inboundRulesHTML + $outboundRulesHTML
$combinedHTML | Out-File C:\EnabledFirewallRules.html

# Invoke the HTML file
Invoke-Item C:\EnabledFirewallRules.html
