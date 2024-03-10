#!/bin/bash 
tsc --init;
npm init -y;
tsJsonAttributes=("rootDir" "outDir");
tsDirectories=("src" "target");
sharedDir=${tsDirectories[0]}/shared;
authentificationDir="$sharedDir/authentification";
middlewareDir="$authentificationDir/middleware";
skeletonProjectDir="$HOME/Document/projects/melkart/chilift/backend/typescript/auth-chilift/src";
skeletonShared="$skeletonProjectDir/shared";
skeletonAuthentification="$skeletonShared/authentification";
skeletonMiddleware="$skeletonAuthentification/Middlewares";
authentificatingEntityWithTs=${1#auth};
authentificatingEntity=${authentificatingEntityWithTs%.ts};
echo "$authentificatingEntityInterface";
for i in ${!tsJsonAttributes[@]};do
    mkdir ${tsDirectories[$i]};
    sed -i "s/\/\/\ \"${tsJsonAttributes[$i]}\": \".\/\"/\"${tsJsonAttributes[$i]}\": \"${tsDirectories[$i]}\"/" tsconfig.json;
done
cp -r $skeletonShared $skeletonProjectDir/types $skeletonProjectDir/environment.d.ts $skeletonProjectDir/index.ts $skeletonProjectDir/.env ./src;
mv $authentificationDir/Middlewares $middlewareDir;
mv $middlewareDir/AuthTokenRequired.ts $middlewareDir/$1;
mv "$authentificationDir/models/User.ts" "$authentificationDir/models/${authentificatingEntityWithTs^}";
mv "$authentificationDir/routes/authRoutes.ts" "$authentificationDir/routes/${authentificatingEntityWithTs^}"
sed -i "s/user/$authentificatingEntity/g" $middlewareDir/$1;
sed -i "s/User/${authentificatingEntity^}/g" $middlewareDir/$1;
sed -i "s/User/"${authentificatingEntity^}"/g" "$authentificationDir/models/${authentificatingEntityWithTs^}";
sed -i "s/user/"${authentificatingEntity}"/g" "$authentificationDir/models/${authentificatingEntityWithTs^}";
sed -i "s/User/"${authentificatingEntity^}"/g" "$authentificationDir/routes/${authentificatingEntityWithTs^}";
sed -i "s/user/"${authentificatingEntity}"/g" "$authentificationDir/routes/${authentificatingEntityWithTs^}";
xargs npm i <$HOME/.config/nodeDependencies.txt;
xargs npm i -D <$HOME/.config/nodeDevDependencies.txt;
