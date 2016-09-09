# Script de Instalacao do Totem
# V6.3
# Author - Helio Passarelli
# Author - Alexander Vieira


$versao = "6.3";

# Para caso de erro, vai para o catch
$ErrorActionPreference = "Stop"

# Caminho para saida do log
$outPadronizaMaquina_MudaHostName = "C:\Suporte\Totem\LOG_CO_PadronizaMaquina_MudaHostName.txt"

# Define ExectutionPolicy
Set-ExecutionPolicy -Scope CurrentUser Unrestricted

# Funcao que inicia o script
function inicia {
  Write-Output "Script de Instalacao do Totem"
  cmd /c pause
  iniciaLog
}

# Funcao que comeca a gravar o log
function iniciaLog {
  # Gravando Log
  $startTime = Get-Date
  Write-Output "Versao $versao - O script iniciou as $startTime"
  Write-Output "Versao $versao - O script iniciou as $startTime" | Out-File $outPadronizaMaquina_MudaHostName
  Write-Output "-"
  Write-Output "-" | Out-File -Append $outPadronizaMaquina_MudaHostName
  perguntaUnidade
}

# Pergunta o Nome da Unidade
function perguntaUnidade {
  try {
    # ---- Codigo ----
    $global:unidade = Read-Host "Digite o Nome da Unidade"
    $unidade = $unidade.ToUpper()

    # ---- Codigo ----
    $time = Get-Date
    Write-Output "Sucesso - Pergunta o Nome da Unidade - $time"
    Write-Output "Sucesso - Pergunta o Nome da Unidade - $time" | Out-File -Append $outPadronizaMaquina_MudaHostName
  }
  catch {
    $time = Get-Date
    Write-Output "Erro - Pergunta o Nome da Unidade - $time"
    Write-Output "Erro - Pergunta o Nome da Unidade - $time" | Out-File -Append $outPadronizaMaquina_MudaHostName
  }
  mudaHostName
}

# Muda o HostName do Computador
function mudaHostName {
  try {
    # ---- Codigo ----
    $computerName = $unidade + "06"
    (Get-WmiObject Win32_ComputerSystem).Rename($computerName)
    # ---- Codigo ----
    $time = Get-Date
    Write-Output "Sucesso - Muda o HostName do Computador - $time"
    Write-Output "Sucesso - Muda o HostName do Computador - $time" | Out-File -Append $outPadronizaMaquina_MudaHostName
  }
  catch {
    $time = Get-Date
    Write-Output "Erro - Muda o HostName do Computador - $time"
    Write-Output "Erro - Muda o HostName do Computador - $time" | Out-File -Append $outPadronizaMaquina_MudaHostName
  }
  terminaScript
}

# Para o Script
function terminaScript {
  $endTime = Get-Date
  Write-Output "-" | Out-File -Append $outPadronizaMaquina_MudaHostName
  Write-Output "O Script terminou as $endTime.  Tempo total de execucao: $(New-TimeSpan $startTime $endTime)." | Out-File -Append $outPadronizaMaquina_MudaHostName
  Restart-Computer -Force
}

# Chamada da primeira funcao
inicia
