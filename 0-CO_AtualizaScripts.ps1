# Script de Instalacao do Totem COLOMBIA
# V1.0
# Author - Alexander Vieira


$versao = "1.0";

# Para caso de erro, vai para o catch
$ErrorActionPreference = "Stop"

# Caminho para saida do log
$outFileAtualizaScript = "C:\Suporte\Totem\LOG_CO_AtualizaScripts.txt"

# Funcao que inicia o script
function inicia {
    Write-Output "`nScript de Instalacao do Totem COLOMBIA - Atualiza Script`n`n"
    cmd /c pause
    iniciaLog
}

# Funcao que comeca a gravar o log
function iniciaLog {
    # Gravando Log
    $startTime = Get-Date
    Write-Output "Versao $versao - O script iniciou as $startTime"
    Write-Output "Versao $versao - O script iniciou as $startTime" | Out-File $outFileAtualizaScript
    Write-Output "-"
    Write-Output "-" | Out-File -Append $outFileAtualizaScript
    AtualizaScriptColombia
}

# Copia arquivo de configuração do VNC para acesso fora do domínio
function AtualizaScriptColombia {
    try {
        # ---- Codigo ----
        Write-Output "======================== Atualizando Scripts ========================"

        Remove-Item "C:\Suporte\Totem\1-PadronizaMaquina_MudaHostName.ps1" -Recurse -Force
        Remove-Item "C:\Suporte\Totem\2-PadronizaMaquina_ColocaNoDominio.ps1" -Recurse -Force
        Remove-Item "C:\Suporte\Totem\3-instala_totem_usuarioRecepcao.ps1" -Recurse -Force

        Copy-Item ".\1-CO_PadronizaMaquina_MudaHostName.ps1" -Destination "C:\Suporte\Totem" -Recurse -Force
        Copy-Item ".\2-CO_PadronizaMaquina_Usuarios.ps1" -Destination "C:\Suporte\Totem" -Recurse -Force
        Copy-Item ".\3-CO_Instala_Totem_UsuarioTotem.ps1" -Destination "C:\Suporte\Totem" -Recurse -Force

        Write-Output "======================== Scripts Atualizados ========================"

        # ---- Codigo ----
        $time = Get-Date
        Write-Output "Sucesso - Atualiza Scripts - $time"
        Write-Output "Sucesso - Atualiza Scripts - $time" | Out-File -Append $outFileAtualizaScript
    }
    catch {
        $time = Get-Date
        Write-Output "Erro - Atualiza Scripts - $time"
        Write-Output "Erro - Atualiza Scripts - $time" | Out-File -Append $outFileAtualizaScript
    }
    terminaScript
}

# Para o Script
function terminaScript {
    $endTime = Get-Date
    Write-Output "-" | Out-File -Append $outFileAtualizaScript
    Write-Output "O Script terminou as $endTime.  Tempo total de execucao: $(New-TimeSpan $startTime $endTime)." | Out-File -Append $outFileAtualizaScript
    Start-Process $outFileAtualizaScript
}

# Chamada da primeira funcao
inicia