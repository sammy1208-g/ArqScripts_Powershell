Add-Type -AssemblyName System.Windows.Forms  # Importación de librerias : Carga los ensamblados que permiten crear interfaces gráficas en Windows.
Add-Type -AssemblyName System.Drawing   # System.Windows.Forms → controles de UI (botones, texto, etc.)     System.Drawing → manejo de tamaños, colores, fuentes.

# Create form
$form = New-Object System.Windows.Forms.Form    # Crea la ventana principal o formulario
$form.Text = "Input Form"    # Establece el título de la ventana o formulario
$form.Size = New-Object System.Drawing.Size(500,250)   # Define el tamaño (ancho 500, alto 250).
$form.StartPosition = "CenterScreen"    # Hace que la ventana aparezca centrada.

############# Define labels
$textLabel1 = New-Object System.Windows.Forms.Label    # Crea una etiqueta.
$textLabel1.Text = "Input 1:"     # Texto que mostrará la etiqueta.
$textLabel1.Left = 20    # Posición horizontal en la ventana (20px)
$textLabel1.Top = 20     # Posición vertical.(20px desde arriba)
$textLabel1.Width = 120  # Ancho del label.

$textLabel2 = New-Object System.Windows.Forms.Label   # Crea una etiqueta.
$textLabel2.Text = "Input 2:"    # Texto que mostrará la etiqueta.
$textLabel2.Left = 20     # Posición horizontal en la ventana (20px)
$textLabel2.Top = 60      # Posición vertical.(60px desde arriba)
$textLabel2.Width = 120   # Ancho del label.

$textLabel3 = New-Object System.Windows.Forms.Label   # Crea una etiqueta.
$textLabel3.Text = "Input 3:"    # Texto que mostrará la etiqueta.
$textLabel3.Left = 20     # Posición horizontal en la ventana (20px)
$textLabel3.Top = 100     # Posición vertical.(100px desde arriba)
$textLabel3.Width = 120   # Ancho del label.

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox  # Crea una caja de texto.
$textBox1.Left = 150  # Posición horizontal.
$textBox1.Top = 20    # Posición vertical.
$textBox1.Width = 200 # Ancho de la caja.

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox   # Crea una caja de texto.
$textBox2.Left = 150    # Posición horizontal.
$textBox2.Top = 60      # Posición vertical.
$textBox2.Width = 200   # Ancho de la caja.

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox # Crea una caja de texto.
$textBox3.Left = 150  # Posición horizontal.
$textBox3.Top = 100   # Posición vertical.
$textBox3.Width = 200 # Ancho de la caja.

############# Default values
$defaultValue = ""   # Variable con cadena vacía. En las cajas se puede poner un texto por defecto si se desea.
$textBox1.Text = $defaultValue   # Asigna valor inicial a la caja 1.
$textBox2.Text = $defaultValue   # Valor inicial de la caja 2.
$textBox3.Text = $defaultValue   # Valor inicial de la caja 3.

############# OK Button
$button = New-Object System.Windows.Forms.Button   # Crea un botón.
$button.Left = 360  # Posición horizontal ( 360 px a la izquierda)
$button.Top = 140   # Posición vertical (140 px hacia abajo)
$button.Width = 100 # Ancho del botón.
$button.Text = "OK"  # Texto del botón.

############# Button click event
$button.Add_Click({      # Add_Click → Ejecuta ese bloque cuando se hace clic.   
    $form.Tag = @{    # Guarda los valores de las tres cajas.
        Box1 = $textBox1.Text
        Box2 = $textBox2.Text
        Box3 = $textBox3.Text
    }
    $form.Close()   # Cierra la ventana.
})

############# Add controls
$form.Controls.Add($button)   # Agrega el botón.
$form.Controls.Add($textLabel1)   # Agrega la etiqueta 1. Y así con las demás etiquetas y cajas.
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

############# Show dialog
$form.ShowDialog() | Out-Null    # Muestra la ventana y espera a que se cierre.

############# Return values
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3    # Devuelve los textos ingresados por el usuario.
