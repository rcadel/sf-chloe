#!/bin/sh
rm -rf deploy
mkdir deploy
cp -r src/* deploy
rm -rf deploy/input.css
for f in deploy/*.html; do
#This line splits the file name on the delimiter "."
baseName=`echo $f | cut -d "." -f 1`
mv $f $baseName
done
aws s3 sync deploy/ s3://$SF_STJO --exclude "*.*" --content-type "text/html" --profile perso
aws s3 sync deploy/ s3://$SF_STJO --include "*.*" --profile perso
aws cloudfront create-invalidation --distribution-id $SF_STJO_DISTRIBUTION_ID --paths "/*" --profile perso