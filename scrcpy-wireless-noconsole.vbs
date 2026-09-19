Dim fso, ipFile, phoneIp, shell, scriptDir, ipFilePath
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

phoneIp = "10.19.56.62"
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
ipFilePath = scriptDir & "\last_device_ip.txt"

If fso.FileExists(ipFilePath) Then
    Set ipFile = fso.OpenTextFile(ipFilePath, 1)
    phoneIp = Trim(ipFile.ReadLine)
    ipFile.Close
End If

shell.Run """" & scriptDir & "\adb.exe"" connect " & phoneIp & ":5555", 0, True
shell.Run """" & scriptDir & "\scrcpy.exe"" -s " & phoneIp & ":5555", 0, False
