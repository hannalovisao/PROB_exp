Choose between zodmini and zod in config.yaml

Run following commands:
chmod +x convert_zod_annotations.sh
nohup ./convert_zod_annotations.sh &

Run this command to convert the annotations to only the id, run this in the directiory with the zod annotations: 
for file in *.xml; do mv "$file" "${file:0:6}.xml"; done
 
