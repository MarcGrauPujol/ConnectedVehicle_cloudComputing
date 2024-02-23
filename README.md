# ConnectedVehicle_cloudComputing
-----------------------PASO 1 - BACKEND- -------------------------------------------------
1. Crear un bucket s3 con el nombre static-website-state para el backend de Terraform


-----------------------PASO 2 - SNS-TOPIC- -------------------------------------------------
1. Acceder al fichero: ConnectedVehicle_cloudComputing/terraform/sns_topic/main.tf
    - comprobar que la region es la "us-east-1", sino, hay que cambiarlo en el mismo fichero
2. Path: ConnectedVehicle_cloudComputing/terraform/sns_topic

$terraform init
$terraform apply

    - Pedirá: topic_email
    - Confirmar la solicitud de subscripción del tópico en el correo introducido


-----------------------PASO 3 - STATIC-WEBSITE - -----------------------------------------
1. ir al path: /ConnectedVehicle_cloudComputing/terraform/modules/staticwebsite

$terraform init
$terraform apply

    - nombre del bucket: puede ser cualquiera
    - nombre del dominio de domain name: puede ser cualquiera

2. Ir al bucket s3 --> Subir manualmente los ficheros para la web estatica (add files) index.html, telemetry.html y error.html. Seguidamente, con la opción "add folder" añadir las carpetas css, fonts, images y js una por una. (por algun motivo no me funciona usando terraform)

![Bucket s3 files](https://github.com/MarcGrauPujol/ConnectedVehicle_cloudComputing/blob/main/s3-bucket-objects.png)

3. Ir al bucket s3 --> permissions --> Block public access (bucket settings) settear a OFF  (Permission denied desde Terraform)
4. Ir al punto de distribución creado con CloudFront --> copiar el domain name a un navegador (debería de verse el index.html)


-----------------------PASO 4 -CLOUDWATCH-ALARMS - ------------------------------------------

0. Primero hay que crear la RDS, sino, no se generan las métricas que se usan para las alarmas de CloudWatch

<!-- 1. Acceder al fichero: ConnectedVehicle_cloudComputing/terraform/modules/cloudwatch/alarms/lookup.tf
    - Sustituir el nombre del topic que hay hardcoded por el nombre del topico creado anteriormente (paso 2). Para ver el nombre, simplemente hay que ir al servicio Amazon SNS y ir a la opcion Topics, alli se listan todos los que estan creados. -->
<!-- Esto ya no hace falta, ahora por defecto el nombre del topic es el mismo siempre. -->
2. Acceder al fichero: ConnectedVehicle_cloudComputing/terraform/rds/alarm.tf
    - Cambiar el nombre de la DB (DB Identifier) en el campo DBInstanceIdentifier por el de la RDS ya creada
3. La alarmas para el bucket s3, se crean en el paso anterior, asi que en este mismo momento ya deberían estar creadas.
4. Path: ConnectedVehicle_cloudComputing/terraform/rds


$terraform init
$terraform apply


------------------------------------------------------------------------------------------------------

MONITORING
1. Las alarmas y sns topic:
    - Automáticamente se manda un email a la dirección que se indique en la entrada cuando una alarma se activa.
    - Hay un único "problema" y es que tanto el nombre de la base de datos (para las alarmas) está hardcoded en el código, asi que hay que tener OJO con esto!