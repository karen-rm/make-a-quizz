# makequizz
<hr>

## Descripción
MakeQuizz es una aplicación pensada para que los profesores puedan crear, administrar y consultar evaluaciones desde su dispositivo móvil, integrándose con la aplicación compañera “TakeQuizz”, utilizada por los estudiantes para responder los cuestionarios.

## Demo 
Creación de cuestionarios:

https://github.com/user-attachments/assets/819a3f4e-04c3-4871-b39a-961595124326

Modificación de cuestionarios:

https://github.com/user-attachments/assets/480da0e6-6fd7-4be4-8333-148932592e6f

Eliminación de cuestionarios:

https://github.com/user-attachments/assets/b54f8619-d962-4331-8c76-642097f2c4e3

Estadísticas por cuestionario: 

https://github.com/user-attachments/assets/be4782e8-2c75-4f48-8c4f-39d26e0f6a01


## Features 

- Creación, edición y eliminación de cuestionarios.
- Administración de preguntas asociadas a cada cuestionario.
- Generación automática de códigos únicos para la integración con TakeQuizz.
- Seguimiento del rendimiento estudiantil por cuestionario.
- Identificación de los mejores y peores resultados obtenidos.
- Análisis de tiempos de resolución de los estudiantes.
- Métricas de aprobación por cuestionario.

## Arquitectura
Este proyecto forma parte de una solución compuesta por dos aplicaciones Flutter que comparten una misma API REST como fuente central de datos:

Aplicación Administrativa (este repositorio)
Creación y gestión de cuestionarios.
Administración de preguntas.
Consulta de estadísticas y resultados.
Modificación y eliminación de cuestionarios.

Aplicación para Alumnos
Consulta y resolución de cuestionarios.
Registro de respuestas.
Envío de resultados al sistema.

La aplicación sigue una arquitectura cliente-servidor. El frontend desarrollado en Flutter actúa como cliente y realiza solicitudes HTTP a través de la clase ApiService, que centraliza y encapsula toda la comunicación con el backend.

ApiService es responsable de consumir los endpoints de la API REST para operaciones como creación, consulta, actualización y eliminación de cuestionarios, preguntas y resultados.

Puede consultar la API REST en este repositorio:  
https://github.com/karen-rm/api-moviles  

El acceso a la base de datos se encuentra completamente desacoplado del frontend. Ninguna de las aplicaciones interactúa directamente con la base de datos; todas las operaciones son gestionadas por el backend mediante la API REST.

## Tecnologias
Flutter
Android Studio 
Railway
PostgreSQL

# Instalación

## Prerrequisitos

* Flutter SDK
* Android Studio
* Dart SDK (incluido con Flutter)

Verifique que Flutter se encuentre correctamente instalado:

```bash
flutter doctor
```

## Clonar el repositorio

```bash
git clone https://github.com/karen-rm/make-a-quizz
cd makequizz
```

## Instalar dependencias

```bash
flutter pub get
```

## Ejecutar la aplicación

```bash
flutter run
```

## Consideraciones

Esta aplicación consume una API REST externa para la gestión de cuestionarios, preguntas y estadísticas.

Actualmente el backend utilizado durante el desarrollo ya no se encuentra desplegado, por lo que para ejecutar completamente la aplicación es necesario:

1. Desplegar una instancia propia de la API REST. Puede hacerlo clonando este repositorio: 

https://github.com/karen-rm/api-moviles 

2. Actualizar la variable `baseUrl` en `services/api_service.dart` con la URL correspondiente.

Sin una instancia activa del backend, la interfaz puede ejecutarse, pero las funcionalidades que dependen de datos remotos no estarán disponibles.


## Notas 
