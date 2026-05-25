# Actividad de Diseño y Arquitecturas de Despliegue (DAD) - Docker

---

**Alumno:** Loyola Lautaro Alejandro  
**Materia:** Diseño y Arquitecturas de Despliegue  
**Repositorio de Referencia:** [joseluisgs/docker-tutorial](https://github.com/joseluisgs/docker-tutorial/tree/master)

---

## 🐳 Desarrollo de Ejercicios

### 🔹 Ejemplo 01: Edición en Contenedor e Integración con VS Code
El objetivo fue compilar una imagen de Apache, acceder de forma interactiva a su shell, configurar repositorios archivados de Linux, editar código internamente y establecer una conexión remota con Visual Studio Code.

1. **Construcción y Acceso:**
   Se buildeó la imagen local y se levantó el contenedor en modo interactivo:
   ```powershell
   docker build -t ejem01 .
   docker run -it ejem01

2. **Configuración de APT e Instalación de Vim:**
Al usar una base antigua de Debian Stretch, los repositorios estándar fallaban. Se redirigieron las fuentes a los  servidores de archivo **(archive.debian.org)** y se actualizó ignorando las firmas de tiempo caducadas:
   ``` bash
   cat /etc/apt/sources.list
   
   deb [http://archive.debian.org/debian](http://archive.debian.org/debian) stretch main
   deb [http://archive.debian.org/debian-security](http://archive.debian.org/debian-security) stretch/updates main

# Actualización forzada e instalación de Vim
  ``` bash
   apt-get update -o Acquire::Check-Valid-Until=false
   apt-get install vim -y
   ```
3. **Edición del Sitio Web (index.html):**
Se abrió el archivo con el comando **vi index.html.** Usando la tecla **i** se activó el modo inserción para registrar los datos del alumno (Nombre, Fecha y Materia). Finalmente, se guardaron los cambios con **ESC + :wq**.

*Despliegue del sitio modificado desde el contenedor:*

4. **Troubleshooting con VS Code (Dev Containers):**
Al intentar conectar la extensión **Remote Explorer** de VS Code, el agente fallaba debido a una incompatibilidad con la librería de **C (GLIBC)** por la versión obsoleta de **PHP 7.0**.

**Solución:** Se actualizó el entorno de la imagen a **PHP 8.2** y se relanzó el contenedor, permitiendo la edición remota exitosa.

<img width="1228" height="158" alt="1" src="https://github.com/user-attachments/assets/2da80510-1038-4415-a05c-557e4d3a07c2" />

<img width="1279" height="674" alt="3" src="https://github.com/user-attachments/assets/ffb3d729-1d56-4cfb-8074-69aff8860469" />

---

### 🔹Ejemplo 02: Interpretación y Portabilidad de Scripts
Se analizó el script ejecutable **run.sh.** Dado que los scripts de terminal **(.sh o .bash)** no son nativos de Windows, su ejecución directa produce errores en la consola estándar.

**Solución aplicada:** Se interpretaron las instrucciones lógicas del script y se consolidaron en un único comando largo adaptado para Windows PowerShell, logrando compilar la imagen (ejem02) y desplegarla sin necesidad de un emulador de terminal Linux.

<img width="1276" height="630" alt="2" src="https://github.com/user-attachments/assets/7631afdc-dcb5-4c0d-835c-3e3e9992da1e" />

---

### 🔹Ejemplo 03: Redes en Docker (WordPress + MariaDB)
En esta sección se desplegó una arquitectura multi-servicio (sitio web conectado a una base de datos relacional) de forma manual.

1. **Análisis de Portabilidad:**
Se evidenció la baja portabilidad que presentan los scripts de S.O. **(.sh)** en entornos multiplataforma **(Windows vs. Linux)**, lo que resalta la importancia de migrar hacia herramientas declarativas de orquestación.

2. **Creación de la Red Virtual:**
Para permitir la comunicación directa por nombre de contenedor, se creó una red de tipo bridge aislada:
   ``` powershell
   docker network create Word_red_ejem03

3. **Lanzamiento de MariaDB:**
Se desplegó el motor de base de datos asociándolo a la red y montando un volumen persistente:
   ``` powershell
   docker run -d --name wordpress-db --net=Word_red_ejem03 --mount source=wordpress-db,target=/var/lib/mysql -e  MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=WordPress -e MYSQL_USER=manager -e MYSQL_PASSWORD=secret mariadb:10.3.9

4. **Lanzamiento y Corrección de WordPress:**
Inicialmente, el contenedor de WordPress fallaba al intentar enlazar con la base de datos.

**Solución:** Se inyectó la variable de entorno explícita **-e WORDPRESS_DB_HOST=mysql** junto con las credenciales correspondientes y el mapeo al puerto local **8085**.
   ``` powershell
docker run -d --name wordpress --net=Word_red_ejem03 --link wordpress-db:mysql --mount type=bind,source="$(pwd)"/wordpress,target=/var/www/html -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DB_USER=manager -e WORDPRESS_DB_PASSWORD=secret -e WORDPRESS_DB_NAME=WordPress -p 8085:80 wordpress:4.9.8
   ```
*Paso inicial de configuración de WordPress en localhost:*

<img width="1279" height="670" alt="Captura de pantalla 2026-05-15 173837" src="https://github.com/user-attachments/assets/283b2a96-2317-441d-9537-3fde558db047" />

---

### 🔹Ejemplo 07: Orquestación Declarativa con Docker Compose
Para solucionar definitivamente los problemas de comandos extensos en PowerShell y la falta de portabilidad, se estructuró el despliegue mediante un archivo **docker-compose.yml.**

**Modificaciones aplicadas al diseño original:**

Se renombró el identificador de red a **red_ejem07.**

Se modificaron y expusieron puertos alternativos en el Host de desarrollo para evitar colisiones con servicios nativos activos.

Comando de ejecución unificada:
  ``` powershell
docker-compose up -d
  ```

<img width="454" height="417" alt="Captura de pantalla 2026-05-15 173755" src="https://github.com/user-attachments/assets/c7283505-3614-4b67-b6a5-b21d6ace8e78" />

---
