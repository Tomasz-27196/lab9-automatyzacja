# Prosty skrypt sprawdzający certyfikat TLS strony internetowej
# Autor: Lab 9
# Data: automatyczna

$Domain = "google.com"
$Port = 443
$ReportFile = "../../reports/tls-report.txt"

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect($Domain, $Port)

    $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false)
    $sslStream.AuthenticateAsClient($Domain)

    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $sslStream.RemoteCertificate

    $now = Get-Date
    $status = if ($cert.NotAfter -gt $now) { "WAŻNY" } else { "NIEWAŻNY" }

    $output = @"
RAPORT TLS
==========
Domena: $Domain
Wystawca: $($cert.Issuer)
Ważny od: $($cert.NotBefore)
Ważny do: $($cert.NotAfter)
Status: $status
"@

    $output | Out-File -FilePath $ReportFile -Encoding UTF8

    Write-Output $output
}
catch {
    "BŁĄD: Nie udało się sprawdzić certyfikatu." | Out-File -FilePath $ReportFile
}
