# Script de ConfiguraÃ§Ã£o Desktops SmartFit
# V1.0
# Author - Helio Passarelli
# Author - Alexander Vieira

clear-host

$versao = "1.0";

# Para caso de erro, vai para o catch
$ErrorActionPreference = 'Continue'

# Caminho para saida do log
$outPadronizaMaquina_Usuarios = "C:\Suporte\Totem\LOG_CO_PadronizaMaquina_Usuarios.txt"

# Funcao que inicia o script
function inicia {
  Write-Output "Script de Adequacao usuarios"
  cmd /c pause
  iniciaLog
}

# Funcao que comeca a gravar o log
function iniciaLog {
  # Gravando Log
  $startTime = Get-Date
  Write-Output "Versao $versao - O script iniciou as $startTime"
  Write-Output "Versao $versao - O script iniciou as $startTime" | Out-File $outPadronizaMaquina_Usuarios
  Write-Output "-"
  Write-Output "-" | Out-File -Append $outPadronizaMaquina_Usuarios
  CreateUsers
 
}

Function CreateUsers {

    try{

        Write-Host "`nCriando os usuários..."
        $users = Get-WmiObject Win32_UserAccount
        net user admin /del 2>&1>$null
        net user teste /del 2>&1>$null
        net user bio-admin B!o@dm1n /add /comment:"Usuario admin" 2>&1>$null
        net user Smart-Totem Smart1234 /add /comment:"Usuario Totem" 2>&1>$null
        net user smart-admin Sm4rtSup /add /comment:"Usuario admin" 2>&1>$null
        net localgroup Administradores bio-admin /add 2>&1>$null
        net localgroup Administradores smart-admin /add 2>&1>$null
        net localgroup Administradores Smart-Totem /add 2>&1>$null
        net user bio-admin B!o@dm1n /active:yes /expires:never /passwordchg:no 2>&1>$null
        net user smart-admin Sm4rtSup /active:yes /expires:never /passwordchg:no 2>&1>$null
        net user smart smart /add /comment:"Usuario limitado" 2>&1>$null
        net user smart smart /active:yes /expires:never /passwordchg:no 2>&1>$null
        WMIC USERACCOUNT WHERE "Name='smart'" SET PasswordExpires=FALSE 2>&1>$null
        WMIC USERACCOUNT WHERE "Name='smart-admin'" SET PasswordExpires=FALSE 2>&1>$null
        REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f 2>&1>$null
        REG DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f 2>&1>$null
     
            # ---- Codigo ----
            $time = Get-Date
            Write-Output "Sucesso - Cria usuarios - $time"
            Write-Output "Sucesso - Cria usuarios - $time" | Out-File -Append $outPadronizaMaquina_Usuarios


    }
        catch {
                $time = Get-Date
                Write-Output "Erro - Cria usuarios - $time"
                Write-Output "Erro - Cria usuarios - $time" | Out-File -Append $outPadronizaMaquina_Usuarios
            }
             terminaScript
        
}

# Para o Script
function terminaScript {
    $endTime = Get-Date
    Write-Output "-" | Out-File -Append $outPadronizaMaquina_Usuarios
    Write-Output "O Script terminou as $endTime.  Tempo total de execucao: $(New-TimeSpan $startTime $endTime)." | Out-File -Append $outPadronizaMaquina_Usuarios
    Start-Process $outPadronizaMaquina_Usuarios
    Restart-Computer -Force

}

#menu inicial
# inicio do script
inicia