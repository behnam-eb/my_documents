param (
    $localPath = "E:\DB-Sync\Logs\",
    $remotePath = "/opt/Chmail/jetty-distribution-8.1.17.v20150415/logs/mail_report_mssql.dir/",
    $database = 'tamin',
	$server = 'maillog',
	$table = 'dbo.log',
	$logServer = 'mail-1.tamin.ir',
    $user = 'root',
	$pass = 'K62%%bV0O**v*sZIuXMM94rtr',
	$serverfingerprint= 'ssh-rsa 2048 dc:20:41:fe:70:19:18:f6:39:30:5b:b9:82:ff:25:ce',
	$sshlogname = 'ssh' ,
	$errlogname = 'error' ,
	$mylogname = 'sqlerr',
	$mailserver = 'mail-1.tamin.ir',
	$mailfrom = 'taminlogger <taminloger@taminlog.local>',
	$mailto =  'test1@chmail.ir'
	
	)
         
try
{
	set-psdebug -off
	#set-psdebug -trace 2
	
	$n = 0
	$date = Get-Date 
	$logtime = $date.ToString('yyyy-MMM-d__hh')
	$date=$date.AddDays(-1) 
	$d= $date.ToString('yyyy-MMM-d')
	$errorLog= $localPath + $errlogname + $d + '.log'
	$mylog= $localPath + $mylogname + $d + '.log'
	$file = "log-" + $d + ".csv"
	$path=$localPath + "\csv-files\" +  $file 
	$sshlog = $localPath + $sshlogname + $logtime + '.log'
	$path | Out-File -filepath $myLog -Append
	$path | Out-File -filepath  $errorLog -Append
 # Load WinSCP .NET assembly
    Add-Type -Path "E:\DB-Sync\WinSCPnet.dll"
	$mailsubject = "import log status of " + $d
	$mailbody = "see attachments " + $logtime
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $logServer 
        UserName = $user 
        Password = $pass
        SshHostKeyFingerprint = $serverfingerprint
    }
 
    $session = New-Object WinSCP.Session -Property @{
	#DebugLogLevel="0"
	#DebugLogPath=$localPath + "ssh-debug.log"
	SessionLogPath= $sshlog
	
	}
 
    try
    {
		
        # Connect
        $session.Open($sessionOptions) 
 
        # Format timestamp
        #$stamp = $(Get-Date -Format "yyyyMMddHHmmss")
		# Download the file and throw on any error
        $session.GetFiles(
            ($remotePath + $file),
            ($localPath )).check()


    }
    catch {
   $_ | Out-File -filepath  $errorLog -Append
   $mailsubject = "Error" + $mailsubject 
   send-mailmessage -SmtpServer $mailserver  -From $mailfrom -to $mailto -Subject $mailsubject -BodyAsHtml -Body $mailbody -Attachments $errorLog
   exit 1
 }
	finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }

	
 Import-Csv -Path $path -Header Srecipient, Rrecipient, Stime, Deliverytime, Qid, Dsn, Comment |  ForEach-Object {
 $n++
 $escaped = $_.Comment.Replace("'", "''")
	try { 
		Invoke-Sqlcmd  -ErrorVariable sqlerror  -Database $database -ServerInstance $server   -Query  "insert into $table VALUES ('$($_.Srecipient)','$($_.Rrecipient)','$($_.Stime)','$($_.Deliverytime)','$($_.Qid)','$($_.Dsn)','$escaped')"  
   if ($sqlerror) { 
      $n | Out-File -filepath $myLog -Append
				
   $sqlerror | Out-File -filepath $myLog -Append
				}
		
		
		
		}
 catch {
   $_ | Out-File -filepath  $errorLog -Append
   $mailsubject = "Error" + $mailsubject 
   send-mailmessage -SmtpServer $mailserver  -From $mailfrom -to $mailto -Subject $mailsubject -BodyAsHtml -Body $mailbody -Attachments $errorLog
   exit 1
 }
 
 }
$attachfile = $mylog , $sshlog , $errorLog
send-mailmessage -SmtpServer $mailserver  -From $mailfrom -to $mailto -Subject $mailsubject -BodyAsHtml -Body $mailbody -Attachments $attachfile   
   #Write-Host $sqlerror

}
catch 
{
    $_ | Out-File -filepath $errorLog -Append
    $mailsubject = "Error" + $mailsubject 
   send-mailmessage -SmtpServer $mailserver  -From $mailfrom -to $mailto -Subject $mailsubject -BodyAsHtml -Body "see error" -Attachments $errorLog
	exit 1
}


