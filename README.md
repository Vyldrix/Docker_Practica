# Actividad de Diseño y Arquitecturas de Despliegue (DAD) - Docker

**Alumno:** Loyola Lautaro Alejandro  
**Materia:** Diseño y Arquitecturas de Despliegue  
**Repositorio de Referencia:** [joseluisgs/docker-tutorial](https://github.com/joseluisgs/docker-tutorial/tree/master)

## 📝 Descripción General
Este repositorio contiene la resolución práctica de la guía de Docker para la materia **Diseño y Arquitecturas de Despliegue**. Durante las prácticas se abarcaron tareas de administración interna de contenedores, solución de dependencias en entornos heredados, migración de scripts de automatización Unix a **Windows PowerShell**, y la orquestación multicontenedor mediante **Docker Compose**.

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



