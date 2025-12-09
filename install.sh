###################################
# Prerequisites     ----> Prerequisitos

# Update the list of packages   ----> Actualizar la lista de paquetes
sudo apt-get update

# Install pre-requisite packages.    ---> Instalar los paquetes previos (requeridos).
sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu  -----> Obtener la versión de Ubuntu
source /etc/os-release

# Download the Microsoft repository keys      ---> Descargar las claves del repositorio de Microsoft
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys    ---> Registrar las claves del repositorio de Microsoft
sudo dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file     ---> Eliminar el archivo de claves del repositorio de Microsoft
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com      ---> Actualiza la lista de paquetes después de agregar packages.microsoft.com
sudo apt-get update

###################################
# Install PowerShell ----> Instalar Powershell
sudo apt-get install -y powershell

# Start PowerShell     --> Empieza Powershell
pwsh
