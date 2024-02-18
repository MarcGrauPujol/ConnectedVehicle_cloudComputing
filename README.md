# ConnectedVehicle_cloudComputing

1. path: /ConnectedVehicle_cloudComputing/terraform/modules/staticwebsite
2. Crear un bucket s3 con el nombre static-website-state para el backend

$terraform init
$terraform apply

1. Ir al bucket s3 --> Subir manualmente el fichero "add files" index.html, telemetry.html y error.html. Seguidamente, con la opción "add folder" añadir las carpetas css, fonts, images y js una por una. (por algun motivo no me funciona usando terraform)

</span><span>(</span><span>https://raw.githubusercontent.com/parzibyte/WaterPy/master/assets/ImagenV1.png</span><span>)</span>

2. Ir al bucket s3 --> permissions --> Block public access (bucket settings) settear a OFF  (Permission denied desde Terraform)
3. Ir al punto de distribución creado con CloudFront --> copiar el domain name a un navegador (debería de verse el index.html)
 