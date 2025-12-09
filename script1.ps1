function Start-ProgressBar{        # Se crea una función llamada Start-ProgressBar.
    [CmdletBinding()]      # Permite que la función se comporte como un cmdlet avanzado (por ejemplo, habilita validación y compatibilidad con el sistema de ayuda).
    param(         # La función recibe dos parámetros obligatorios:
        [Parameter(Mandatory = $true)] 
        $Title,  # $Title → texto que se mostrará como el título de la barra de progreso.
        
        [Parameter(Mandatory = $true)]
        [int]$Timer   # $Timer (int) → número de iteraciones (segundos) que durará la barra de progreso.
    )

    for ($i = 1; $i -le $Timer; $i++) {         # Es un bucle el cual se ejecuta desde 1 hasta el valor de $Timer
        Start-Sleep -Seconds 1;          # Cada iteración espera 1 segundo, simulando un "temporizador".
        $percentComplete = ($i / $Timer) * 100        # Calcula el porcentaje real de progreso.
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete      # Write-Progress es el cmdlet que dibuja la barra en la consola.  -Activity $Title → muestra el título que se definio.  -Status "$i seconds elapsed" → muestra cuántos segundos han pasado.  -PercentComplete $percentComplete → actualiza visualmente la barra de progreso.
    }
} #Function Start-ProgressBar

#Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30 # Se ejecuta la función con: Título: "Test timeout", Duración: 30 segundos
