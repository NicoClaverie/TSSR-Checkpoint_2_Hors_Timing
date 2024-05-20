# Effectué en dehors du timing
###############################################################
#
# Q.2.1 : Pour le partage de fichier j'ai fait un clic droit sur le dossier Scripts sur la racine C: puis cliquer sur properties puis l'onglet Sharing,
#         et ensuite Share puis dans la nouvelle fenetre a nouveaux share car le parametrage par défaut est correct puis done
#         Coté client, j'ai ouvert un explorateur windows et j'ai entrer \\winserv pour aller sur les dossier partagé, une fenetre m'a demander les 
#         identifiants, j'ai mis Administrator / P@ssw0rdAdmin$!2023
#         Et j'ai copié le dossier Scripts sur la racine C: du pc client
#
###############################################################

###############################################################
#
# Main.ps1
#
# Q.2.2
# A l'execution une nouvelle fenetre powershell s'ouvre, affiche un message d'erreur et se ferme aussitot
#
# La seule ligne présente est Start-Process -FilePath "powershell.exe" -ArgumentList "C:\Temp\AddLocalUsers.ps1" -Verb RunAs -WindowStyle Maximized, le FilePath pointe vers C:\temp alors qu'il devrait aller vers C:\Scripts la bonne ligne est 
# Start-Process -FilePath "powershell.exe" -ArgumentList "C:\Scripts\AddLocalUsers.ps1" -Verb RunAs -WindowStyle Maximized
#
# Q.2.3
# -Verb RunAs sert a obtenir une elevation de privilege
#
# Q.2.4
# -WindowsStyle Maximized permet d'avoir d'ouvir une nouvelle fenetre en grand format
#
###############################################################

###############################################################


Write-Host "--- Début du script ---"
# Q.2.14 Modification de la longueur de mot de passe en modifiant la variable $length de 6 a 12
Function Random-Password ($length = 12)
{
    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122

    $password = get-random -count $length -input ($punc + $digits + $letters) |`
        ForEach -begin { $aa = $null } -process {$aa += [char]$_} -end {$aa}
    Return $password.ToString()
}

Function ManageAccentsAndCapitalLetters
{
    param ([String]$String)
    
    $StringWithoutAccent = $String -replace '[éèêë]', 'e' -replace '[àâä]', 'a' -replace '[îï]', 'i' -replace '[ôö]', 'o' -replace '[ùûü]', 'u'
    $StringWithoutAccentAndCapitalLetters = $StringWithoutAccent.ToLower()
    $StringWithoutAccentAndCapitalLetters
}
# Q.2.9 J'ai choisi de copier/coller l'ensemble du fichier "Functions.psm1" pour avoir la fonction Log directement sur le script
function Log
{
# Q.2.9 Ajout de la ligne pour utiliser la variable $LogFile du script dans la fonction sous le nom $FilePath
    $FilePath = $LogFile
# Message d'erreur présent sur le terme "param" mais l'incrementation du fichier Log.log fonctionne correctement
    param([string]$FilePath,[string]$Content)

    # Vérifie si le fichier existe, sinon le crée
    If (-not (Test-Path -Path $FilePath))
    {
        New-Item -ItemType File -Path $FilePath | Out-Null
    }

    # Construit la ligne de journal
    $Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$Date;$User;$Content"

    # Ajoute la ligne de journal au fichier
    Add-Content -Path $FilePath -Value $logLine
}

$Path = "C:\Scripts"
$CsvFile = "$Path\Users.csv"
$LogFile = "$Path\Log.log"
# Q.2.5 pour que le premier utilisateur du fichier Users.csv soit pris en compte il faut ecrire select-object -skip 1
# Q.2.7 Suppression des elements inutile pour la creation des utilisateurs "societe","fonction","service" "mail","mobile","scriptPath","telephoneNumber"
$Users = Import-Csv -Path $CsvFile -Delimiter ";" -Header "prenom","nom","description" -Encoding UTF8  | Select-Object -Skip 1

foreach ($User in $Users)
{
    $Prenom = ManageAccentsAndCapitalLetters -String $User.prenom
    $Nom = ManageAccentsAndCapitalLetters -String $User.Nom
# Q.2.6 Ajout de la variable description avec l'application de la fonction qui format l'ecriture qui n'apparaissait pas avant 
    $Description = ManageAccentsAndCapitalLetters -String $User.description
# Q.2.12 Ajout de la variable $name qui reprend les deux variables $Prenom et $Nom
    $Name = "$Prenom.$Nom"
    If (-not(Get-LocalUser -Name $Name -ErrorAction SilentlyContinue))
    {
        $Pass = Random-Password
        $Password = (ConvertTo-secureString $Pass -AsPlainText -Force)
        $Description = "$($user.description) - $($User.fonction)"
        $UserInfo = @{
            Name                 = $Name
            FullName             = $Name
# Q.2.6 Ajout de la ligne description qui n'apparaissait pas avant 
            Description          = $Description
            Password             = $Password
            AccountNeverExpires  = $true
# Q.2.13 modification de la valeur $false a $true pour rendre le mot de passe non expirable 
            PasswordNeverExpires = $true
        }

        New-LocalUser @UserInfo
# Q.2.9 Ajout d'une ligne pour journaliser la creation d'un utilisateur
        $Content = " Creation de  l'utilisateur $Name avec le mot de passe $Pass"
        Log
# Q.2.11 Il manque le S a utilisateurs, 
        Add-LocalGroupMember -Group "Utilisateurs" -Member $Name
# Q.2.9 Ajout d'une ligne pour journaliser l'ajout d'un utilisateur au groupe utilisateurs
        $Content = " Ajout de  l'utilisateur $Name au groupe utilisateurs"
        Log
# Q.2.8 Ajout de la variable $pass qui indique le mot de passe genere aleatoirement et affichage de la ligne en vert
        Write-Host "Le compte $Name a été crée avec le mot de passe $Pass" -ForegroundColor Green
    }
# Q.2.10 Ajout de la ligne avec le "else" pour la vérification de l'existance de l'utilisateur et affichage en rouge
    else { write-host " Le compte $Name existe déjà "  -ForegroundColor Red
# Q.2.9 Ajout d'une ligne pour journaliser que l'utilisateur existe deja 
        $Content = " Le compte $Name existe déjà "
        Log
    
     }
}

pause
Write-Host "--- Fin du script ---"
# Q.2.15 modification de la temporisation de 10 seconds pour la gerer avec un appuie sur la touche entrée
Pause

# Q.2.16  la fonction ManageAccentsAndCapitalLetters sert a formater les lettres du fichier CSV, il supprime les accents et enleve les majuscule, exemple Anaïs Bourgeois devient anais bourgeois
