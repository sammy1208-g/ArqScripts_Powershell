# script3.ps1
function New-FolderCreation {     # Define una nueva función llamada New-FolderCreation.
    [CmdletBinding()]         # Habilita características avanzadas de cmdlet (como parámetros obligatorios).
    param(    # Inicio de parámetros.
        [Parameter(Mandatory = $true)]
        [string]$foldername     # Define un parámetro obligatorio llamado foldername (tipo string).
    )

    # Create absolute path for the folder relative to current location
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername    # Crea la ruta completa combinando la carpeta actual con el nombre del folder.
    if (-not (Test-Path -Path $logpath)) {   # Nos dice: Si la carpeta no existe…
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null    # La crea (y oculta la salida).
    }

    return $logpath    # Devuelve la ruta creada.
}

function Write-Log {     # Define la función principal para crear logs o escribir mensajes.
    [CmdletBinding()]    # Activa el comportamiento avanzado del cmdlet.
    param(    # Inicio de los parámetros.
        # Create parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [Alias('Names')]
        [object]$Name,                    # can be single string or array      # Nombre del archivo(s) a crear (acepta string o array).

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext,     # Extensión del archivo.

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder,     # Carpeta donde se guardará el archivo.

        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create,     # Switch que indica que se usará el modo Create.

        # Message parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message,     # Mensaje a escribir.

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path,       # Ruta del archivo donde se escribirá el mensaje.

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',      # Nivel del mensaje (color y tipo).

        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG     # Switch que indica que se usará el modo Message.
    )

    switch ($PsCmdlet.ParameterSetName) {     # Determina qué conjunto de parámetros se está usando.
        "Create" {    # Entra al modo Create.
            $created = @()    # Array para guardar rutas creadas.

            # Normalize $Name to an array
            $namesArray = @()   # Inicializa un array vacío para los nombres.
            if ($null -ne $Name) {   # Dice que: Si Name no está vacío…
                if ($Name -is [System.Array]) { $namesArray = $Name }
                else { $namesArray = @($Name) }     # Convierte Name en un array sí o sí.
            }

            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd")
            $time  = (Get-Date -Format "HH-mm-ss")   # Fecha y hora formateadas para nombres de archivo.

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder    # Se asegura que la carpeta existe y devuelve su ruta.

            foreach ($n in $namesArray) {   # Procesa cada nombre.
                # sanitize name to string
                $baseName = [string]$n      # Convierte el nombre a string.

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext"   # Construye el nombre final del archivo.

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName   # Ruta completa del archivo.

                # Create the file (New-Item -Force will create or overwrite; use -ErrorAction Stop to catch errors)
                try {
                    # If you prefer to NOT overwrite existing file, use: if (-not (Test-Path $fullPath)) { New-Item ... }
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null     # Crea el archivo; si falla, lanza error.

                    # Optionally write a header line (uncomment if desired)
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append

                    $created += $fullPath   # Guarda la ruta creada.
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_"     # Muestra advertencia si ocurre un error.
                }
            }

            return $created    # Devuelve todas las rutas creadas.
        }

        "Message" {    # Modo para escribir mensajes.
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent    # Obtiene la carpeta contenedora del archivo.
            if ($parent -and -not (Test-Path -Path $parent)) {
                New-Item -Path $parent -ItemType Directory -Force | Out-Null     # Crea la carpeta si no existe.
            }

            $date = Get-Date    # Obtiene la fecha actual.
            $concatmessage = "|$date| |$message| |$Severity|"   # Arma el mensaje final.

            switch ($Severity) {     # Cambia color según severidad.
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

            # Append message to the specified path (creates file if it does not exist)
            Add-Content -Path $path -Value $concatmessage -Force    # Escribe el mensaje en el archivo (lo crea si no existe).

            return $path    # Devuelve la ruta del archivo.
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"     # Error si no se reconoce el parámetro.
        }
    }
}

# ---------- Example usage ----------
# This will create the folder "logs" (if missing) and create a file Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create     # Crea una carpeta “logs” y un archivo log con fecha/hora.
$logPaths    # Muestra las rutas creadas.