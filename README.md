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

1. Se renombró el identificador de red a **red_ejem07.**
2. Se reemplazaron todas las **rutas absolutas de Linux** (ej. `/home/informatica/...`) por **rutas relativas** (ej. `../mariadb/data:/var/lib/mysql`). Esto garantiza la portabilidad y la persistencia de datos en **Windows** usando Docker Desktop.
3. Se modificaron y expusieron puertos alternativos en el Host de desarrollo para evitar colisiones con servicios nativos activos.

Comando de ejecución unificada con nombre de proyecto:
  ```powershell
docker-compose -p ejem07 up -d --build
  ```

<img width="454" height="417" alt="Captura de pantalla 2026-05-15 173755" src="https://github.com/user-attachments/assets/c7283505-3614-4b67-b6a5-b21d6ace8e78" />

---

### 🔹Ejemplo 08: Adaptación de Scripts y Nombres de Contenedores
Se analizó el script original `run.sh` que lanzaba un contenedor de Apache y PHP.

**Modificaciones aplicadas:**
1. Se cambió el nombre de la imagen y del contenedor de `miapache-php` a **ejem08**.
2. Se ajustó el puerto expuesto en el host al **8088** (`8088:80`) para prevenir bloqueos por puertos en uso.
3. Al estar en Windows, los comandos del script fueron ejecutados directamente en PowerShell unidos por punto y coma (`;`), compilando la imagen y ejecutando el contenedor con éxito.

<img width="1028" height="569" alt="ejem 08" src="https://github.com/user-attachments/assets/d7a03899-1dea-4db6-abab-32213d0263b1" />

---

### 🔹Ejemplo 09: Resolución de Conflictos Multi-Contenedor
Se desplegó una arquitectura que involucra un proxy reverso (Nginx), un servidor web genérico y un servidor Apache, definidos en `docker-compose.yml`.

**Modificaciones aplicadas:**
1. **Prevención de colisiones de nombres:** Se actualizó la propiedad `container_name` para incluir el prefijo del proyecto (`ejem09_reverseproxy`, `ejem09_nginx`, `ejem09_apache`).
2. **Reasignación de puertos:** Los puertos `8080` y `8081` originales estaban en el rango ocupado, por lo que se movieron a **8090** y **8091**.
3. Se ejecutó orquestado con su nombre de proyecto:
  ```powershell
docker-compose -p ejem09 up -d --build
  ```

<img width="1025" height="571" alt="ejem 09" src="https://github.com/user-attachments/assets/d3ae700e-a488-425e-bacd-6f4a67e386d6" />

---

### 🔹Ejemplo 10: Proxy Reverso Avanzado e Integración con Docker Socket
En este ejercicio se orquestaron múltiples servicios donde un contenedor principal (`jwilder/nginx-proxy`) enruta el tráfico hacia distintos servidores web virtuales.

**Modificaciones aplicadas:**
1. **Protección de Puertos Clave:** Se reemplazaron los puertos críticos `80` y `443` por **8092** y **8443** respectivamente.
2. **Nombrado de Contenedores:** Se definieron nombres específicos con el prefijo del entorno (`ejem10_reverseproxy`, `ejem10_nginx`, `ejem10_apache`).
3. **Mapeo de Sockets en Windows:** Se mantuvo intacto el mapeo `- /var/run/docker.sock:/tmp/docker.sock:ro`, validando que Docker Desktop para Windows soporta la comunicación transparente hacia el daemon a través de esta sintaxis heredada de Linux.
4. Se levantó el entorno con el identificador del proyecto:
  ```powershell
docker-compose -p ejem10 up -d --build
  ```

<img width="1023" height="570" alt="ejem 10" src="https://github.com/user-attachments/assets/cb3217c5-e35d-4a22-964b-5bcecc2b85aa" />

---
