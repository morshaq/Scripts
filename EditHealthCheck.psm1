function fnOutFromHAP([string]$MinConToResetIIS,[string]$dest_folder, [string]$status_file, [string]$websitename) {
    $servername = hostname
	# take server from the pool (status file)
	Write-Host "Stop Status file on server" 
	rename-item -path $dest_folder\$status_file -newname $status_file".down"
	# Waiting to n connection on the server
	Write-Host "Waiting while less then $MinConToResetIIS connections on the server on the server" $DRdestination_Name
	$gc= Get-WmiObject -Class Win32_PerfFormattedData_W3SVC_WebService -ComputerName $servername | Where {$_.Name -eq $websitename} | % {$_.CurrentConnections}

	#need to add timeout for this loop : start a clock and add condition to while loop  - when timeout happens  catch the error and write it to EventViewer
    $timeout = new-timespan -Minutes 10
    $sw = [diagnostics.stopwatch]::StartNew()
    $timeoutexit = $true
    
	while ($timeoutexit -eq $true)
	{
		$current_connections = ((Get-Counter -Counter $gc).CounterSamples).CookedValue
		Write-Host "IIS current connection is $current_connections"
        if ($sw -ge $timeout)
        {
            Write-Host "TimeOut 5 min past without current_Connections is reaching" +$MinConToResetIIS
            timeoutexit = $false
        }      
	}
}
function fnBackToHAP ([string]$dest_folder, [string]$status_file) {
    rename-item -path $dest_folder\$status_file".down" -newname $status_file
    Write-Host "server is back in the HAP rotation !"}