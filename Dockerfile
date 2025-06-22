# Environemnt to install flutter and build web
FROM ghcr.io/cirruslabs/flutter:3.32.2 AS build-env

ARG APP=/app/

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# stup new folder as the working directory
WORKDIR $APP

# Run build: 1 - clean, 2 - pub get, 3 - build web
RUN flutter clean
RUN flutter pub get
RUN flutter build web

# once heare the app will be compiled and ready to deploy

# use nginx to deploy
FROM nginx:1.28.0-alpine

# copy the info of the builded web app to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]