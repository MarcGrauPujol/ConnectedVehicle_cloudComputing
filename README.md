# ConnectedVehicle_cloudComputing

1. path: /ConnectedVehicle_cloudComputing/terraform/modules/staticwebsite
2. Crear un bucket s3 con el nombre static-website-state para el backend

$terraform init
$terraform apply

1. Ir al bucket s3 --> Subir manualmente el fichero "add files" index.html, telemetry.html y error.html. Seguidamente, con la opción "add folder" añadir las carpetas css, fonts, images y js una por una. (por algun motivo no me funciona usando terraform)

![Bucket s3 files](https://github.com/MarcGrauPujol/ConnectedVehicle_cloudComputing/blob/main/s3-bucket-objects.png)

2. Ir al bucket s3 --> permissions --> Block public access (bucket settings) settear a OFF  (Permission denied desde Terraform)
3. Ir al punto de distribución creado con CloudFront --> copiar el domain name a un navegador (debería de verse el index.html)

MONITORING
1. Las alarmas y sns topic:
    - Automáticamente se manda un email a la dirección que se indique en la entrada cuando una alarma se activa.
    - Hay un único "problema" y es que tanto el nombre de la base de datos (para las alarmas) como el nombre del topic (en el fichero lookup.tf en el modulo de las alarmas) estan hardcodeados en el código, asi que hay que tener OJO con esto!