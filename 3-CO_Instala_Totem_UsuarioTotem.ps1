# Script de Instalacao do Totem com o usuario da Recepcao
# V6.3
# Author - Helio Passarelli
# Author - Alexander Vieira


$versao = "6.3";

# Para caso de erro, vai para o catch
$ErrorActionPreference = "Stop"

# Caminho para saida do log
$outFileInstalaTotem = "C:\Suporte\Totem\LOG_CO_Instala_Totem_UsuarioTotem.txt"

# Funcao que inicia o script
function inicia {
	Write-Output "`nScript de Instalacao do Totem com o Usuario do Totem`n`n"
	cmd /c pause
	iniciaLog
}

# Funcao que comeca a gravar o log
function iniciaLog {
	# Gravando Log
	$startTime = Get-Date
	Write-Output "Versao $versao - O script iniciou as $startTime"
	Write-Output "Versao $versao - O script iniciou as $startTime" | Out-File $outFileInstalaTotem
	Write-Output "-"
	Write-Output "-" | Out-File -Append $outFileInstalaTotem
	pedeUnidade
}

# Pede e grava a variavel da unidade
function pedeUnidade {
	try {
		# ---- Codigo ----
		Clear-Host
		$global:unidade = Read-Host "Digite o Nome da Unidade"
		$global:ipServidor = Read-Host "Digite o IP do SERVIDOR das Catracas"
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Pede e grava a variavel da unidade - $time"
		Write-Output "Sucesso - Pede e grava a variavel da unidade - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Pede e grava a variavel da unidade - $time"
		Write-Output "Erro - Pede e grava a variavel da unidade - $time" | Out-File -Append $outFileInstalaTotem
	}
	copiaJapaPolicy
}

# Copia o .java.policy para a pasta do Usuario Atual
function copiaJapaPolicy {
	try {
		# ---- Codigo ----
		Copy-Item "C:\Suporte\totem\arquivos\a.java.policy" -Destination "C:\Suporte\totem\arquivos\.java.policy" -Recurse -Force
		Copy-Item "C:\Suporte\totem\arquivos\.java.policy" -Destination $env:HOMEPATH  -Recurse -Force
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Copia o .java.policy para a pasta do Usuario Atual - $time"
		Write-Output "Sucesso - Copia o .java.policy para a pasta do Usuario Atual - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Copia o .java.policy para a pasta do Usuario Atual - $time"
		Write-Output "Erro - Copia o .java.policy para a pasta do Usuario Atual - $time" | Out-File -Append $outFileInstalaTotem
	}
	copiaCertificadoJava
}

# Copia o certificado java para a pasta do Usuario Atual
function copiaCertificadoJava {
	try {
		# ---- Codigo ----
		Copy-Item -Path "C:\Suporte\Totem\arquivos\Sun" -Destination "$env:USERPROFILE\AppData\Roaming\" -Recurse -Force
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Copia o certificado java para a pasta do Usuario Atual - $time"
		Write-Output "Sucesso - Copia o certificado java para a pasta do Usuario Atual - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Copia o certificado java para a pasta do Usuario Atual - $time"
		Write-Output "Erro - Copia o certificado java para a pasta do Usuario Atual - $time" | Out-File -Append $outFileInstalaTotem
	}
	instalamKiosk
}

# Instala o mKiosk
function instalamKiosk {
	try {
		# ---- Codigo ----
		Start-Process "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -ArgumentList '"C:\suporte\totem\arquivos\mkiosk.xpi"' -Wait
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Instala o mKiosk - $time"
		Write-Output "Sucesso - Instala o mKiosk - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Instala o mKiosk - $time"
		Write-Output "Erro - Instala o mKiosk - $time" | Out-File -Append $outFileInstalaTotem
	}
	configuramKiosk
}

# Configura mKiosk
function configuramKiosk {
	try {
		# ---- Codigo ----
		$arqvConfFirefox = (Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\" -Filter "prefs.js" -Recurse).FullName
		if (Get-Process | Where-Object {$_.Name -match "Firefox"}) {
			Get-Process -Name Firefox | Stop-Process
		}
		Copy-Item -Path "C:\Suporte\totem\arquivos\prefs.js" -Destination $arqvConfFirefox
		(Get-Content $arqvConfFirefox).Replace("user_pref(`"browser.startup.homepage`", `"www.smartfit.com.br`");","user_pref(`"browser.startup.homepage`", `"https://app.smartfit.com.br/totem/v2?location=$unidade`");") | Out-File $arqvConfFirefox -Encoding utf8
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Configura mKiosk - $time"
		Write-Output "Sucesso - Configura mKiosk - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Configura mKiosk - $time"
		Write-Output "Erro - Configura mKiosk - $time" | Out-File -Append $outFileInstalaTotem
	}
	mapeiaUnidadeZ
}

# Mapeia Unidade Z:
function mapeiaUnidadeZ {
	try {
		# ---- Codigo ----
		if (Get-PSDrive | Where-Object {$_.Name -eq "Z"}) {
			Remove-PSDrive -Name "Z"
		}
		New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\$ipServidor\fotos" -Persist -Scope Global
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Mapeia Unidade Z: - $time"
		Write-Output "Sucesso - Mapeia Unidade Z: - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Mapeia Unidade Z: - $time"
		Write-Output "Erro - Mapeia Unidade Z: - $time" | Out-File -Append $outFileInstalaTotem
	}
	copiaLnkFirefox
}

# Copia lnk do firefox para iniciar quando usuario logar
function copiaLnkFirefox {
	try {
		# ---- Codigo ----
		Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Mozilla Firefox.lnk" -Destination "$ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Force
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Copia lnk do firefox para iniciar quando usuario logar - $time"
		Write-Output "Sucesso - Copia lnk do firefox para iniciar quando usuario logar - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Copia lnk do firefox para iniciar quando usuario logar - $time"
		Write-Output "Erro - Copia lnk do firefox para iniciar quando usuario logar - $time" | Out-File -Append $outFileInstalaTotem
	}
	usuarioAutoLogon
}

# Coloca o usuario totem local em AutoLogon
function usuarioAutoLogon {
	try {
		# ---- Codigo ----
		$usuarioAtual = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value "1" -Force
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "$usuarioAtual" -Force
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "Smart1234" -Force
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Coloca o usuario totem local em AutoLogon - $time"
		Write-Output "Sucesso - Coloca o usuario totem local em AutoLogon - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Coloca o usuario totem local em AutoLogon - $time"
		Write-Output "Erro - Coloca o usuario totem local em AutoLogon - $time" | Out-File -Append $outFileInstalaTotem
	}
	desativaTecladoVirtual
}

# Desativa o Teclado Virtual
function desativaTecladoVirtual {
	try {
		# ---- Codigo ----
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\TabletTip\1.7" -PropertyType DWORD -Name "IPTipTargetRequiresClick" -Value "1" -Force
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\TabletTip\1.7" -PropertyType DWORD -Name "ShowIPTipTouchTarget" -Value "1" -Force
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\TabletTip\1.7" -PropertyType DWORD -Name "HideEdgeTabOnPenOutOfRange" -Value "1" -Force
		New-ItemProperty "HKLM:\SOFTWARE\Microsoft\TabletTip\1.7" -PropertyType DWORD -Name "EnableFloatingTIPAnimation" -Value "1" -Force
		Set-ItemProperty "HKCU:\Software\Microsoft\TabletTip\1.7" -Name EnableEdgeTarget -Value "0" -Force
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Desativa o Teclado Virtual - $time"
		Write-Output "Sucesso - Desativa o Teclado Virtual - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Desativa o Teclado Virtual - $time"
		Write-Output "Erro - Desativa o Teclado Virtual - $time" | Out-File -Append $outFileInstalaTotem
	}
	desativaMultiTouch
}

# Desativa o MultiTouch
function desativaMultiTouch {
	try {
		# ---- Codigo ----
		Get-ChildItem -Path "Registry::\HKEY_USERS\" | Where-Object {$_.Name -match "S-1-5-21"} | ForEach-Object {
			$pastaRegistroUsuario = ($_.Name).SubString(11);
			if (Test-Path -Path "Registry::\HKEY_USERS\$pastaRegistroUsuario\Software\Microsoft\Wisp") {
				Set-ItemProperty "Registry::\HKEY_USERS\$pastaRegistroUsuario\Software\Microsoft\Wisp\MultiTouch" -Name MultiTouchEnabled -Value "0" -Force
			}
		}
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Desativa o MultiTouch - $time"
		Write-Output "Sucesso - Desativa o MultiTouch - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Desativa o MultiTouch - $time"
		Write-Output "Erro - Desativa o MultiTouch - $time" | Out-File -Append $outFileInstalaTotem
	}
	instalaRuby
}

# Instala o Ruby
function instalaRuby {
	try {
		# ---- Codigo ----
		Start-Process "C:\Suporte\totem\softwares\software - rubyinstaller.exe" -ArgumentList '/verysilent /dir="C:\Ruby187" /tasks="addtk,assocfiles,modpath"' -Wait
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Instala o Ruby - $time"
		Write-Output "Sucesso - Instala o Ruby - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Instala o Ruby - $time"
		Write-Output "Erro - Instala o Ruby - $time" | Out-File -Append $outFileInstalaTotem
	}
	criaAgendamentoStartup
}

# Cria o agendamento para logar o Startup do windows
function criaAgendamentoStartup {
	try {
		# ---- Codigo ----
		$statusAgendamentoLogStartupWindows = schtasks /QUERY /FO LIST /V /TN "logStartupWindows"
		$argTask = "powershell.exe -File `"C:\Suporte\totem\arquivos\logaStartup.ps1`""
		if ([string]::IsNullOrEmpty($statusAgendamentoLogStartupWindows)) {
			schtasks /create /SC ONSTART /TN "logStartupWindows" /TR $argTask /RU "SYSTEM" /F
			Write-Output "`n* O agendamento logStartupWindows nao estava criado, por isso estou criando ele.`n"
			Write-Output "`n* O agendamento logStartupWindows nao estava criado, por isso estou criando ele.`n" | Out-File -Append $outFileInstalaTotem
			$statusAgendamentoLogStartupWindows = schtasks /QUERY /FO LIST /V /TN "logStartupWindows"
			if ([string]::IsNullOrEmpty($statusAgendamentoLogStartupWindows)) {
				Write-Output "`n* A criacao do agendamento logStartupWindows ocorreu, porem nao consta como criado`n"
				Write-Output "`n* A criacao do agendamento logStartupWindows ocorreu, porem nao consta como criado`n" | Out-File -Append $outFileInstalaTotem
			}
			else {
				Write-Output "`n* A criacao do agendamento logStartupWindows foi criado com sucesso`n"
				Write-Output "`n* A criacao do agendamento logStartupWindows foi criado com sucesso`n" | Out-File -Append $outFileInstalaTotem
			}
		}
		else {
			Write-Output "`n* O agendamento logStartupWindows ja estava criado`n`n"
			Write-Output "`n* O agendamento logStartupWindows ja estava criado`n`n" | Out-File -Append $outFileInstalaTotem
		}
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Cria o agendamento para logar o Startup do windows - $time"
		Write-Output "Sucesso - Cria o agendamento para logar o Startup do windows - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Cria o agendamento para logar o Startup do windows - $time"
		Write-Output "Erro - Cria o agendamento para logar o Startup do windows - $time" | Out-File -Append $outFileInstalaTotem
	}
	criaAgendamentoUpdateGems
}

# Cria o agendamento para atualizar as gems
function criaAgendamentoUpdateGems {
	try {
		# ---- Codigo ----
		$statusAgendamentoUpdateGems = schtasks /QUERY /FO LIST /V /TN "Scripts\UpdateGems"
		$argTaskUpdate = "powershell.exe -File `"C:\Suporte\totem\arquivos\UpdateGems.ps1`""
		Copy-Item -Path "C:\Suporte\totem\arquivos\UpdateGems.ps1" -Destination "C:\Ruby187\bin\UpdateGems.ps1" -Force
		if ([string]::IsNullOrEmpty($statusAgendamentoUpdateGems)) {
			schtasks /create /SC DAILY /ST "01:00" /TN "Scripts\UpdateGems" /TR $argTaskUpdate /RU "SYSTEM" /F
			Write-Output "`n* O agendamento UpdateGems nao estava criado, por isso estou criando ele.`n"
			Write-Output "`n* O agendamento UpdateGems nao estava criado, por isso estou criando ele.`n" | Out-File -Append $outFileInstalaTotem
			$statusAgendamentoUpdateGems = schtasks /QUERY /FO LIST /V /TN "Scripts\UpdateGems"
			if ([string]::IsNullOrEmpty($statusAgendamentoUpdateGems)) {
				Write-Output "`n* A criacao do agendamento UpdateGems ocorreu, porem nao consta como criado`n"
				Write-Output "`n* A criacao do agendamento UpdateGems ocorreu, porem nao consta como criado`n" | Out-File -Append $outFileInstalaTotem
			}
			else {
				Write-Output "`n* A criacao do agendamento UpdateGems foi criado com sucesso`n"
				Write-Output "`n* A criacao do agendamento UpdateGems foi criado com sucesso`n" | Out-File -Append $outFileInstalaTotem
			}
		}
		else {
			Write-Output "`n* O agendamento UpdateGems ja estava criado`n`n"
			Write-Output "`n* O agendamento UpdateGems ja estava criado`n`n" | Out-File -Append $outFileInstalaTotem
		}
		# ---- Codigo ----
		$time = Get-Date
		Write-Output "Sucesso - Cria o agendamento UpdateGems - $time"
		Write-Output "Sucesso - Cria o agendamento UpdateGems - $time" | Out-File -Append $outFileInstalaTotem
	}
	catch {
		$time = Get-Date
		Write-Output "Erro - Cria o agendamento UpdateGems - $time"
		Write-Output "Erro - Cria o agendamento UpdateGems - $time" | Out-File -Append $outFileInstalaTotem
	}
	terminaScript
}

# Para o Script
function terminaScript {
	$endTime = Get-Date
	Write-Output "-" | Out-File -Append $outFileInstalaTotem
	Write-Output "O Script terminou as $endTime.  Tempo total de execucao: $(New-TimeSpan $startTime $endTime)." | Out-File -Append $outFileInstalaTotem
	Start-Process $outFileInstalaTotem
}

# Chamada da primeira funcao
inicia
