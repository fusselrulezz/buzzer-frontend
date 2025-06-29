# Builds the Flutter web app and serves it using Nginx
FROM ghcr.io/cirruslabs/flutter:3.32.2 AS build-env

ARG APP=/app/

# Create app directory and set it as the working directory
RUN mkdir $APP
WORKDIR $APP

# Copy pubspec files to the app directory and install dependencies
# Uses SSH mount to access private repositories if needed
COPY pubspec.* $APP
RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh flutter pub get

# Copy the rest of the application code to the app directory and run the build
COPY . $APP
RUN flutter build web

# Serve using nginx
FROM nginx:1.28.0-alpine

# Copy the built web app from the build environment to the nginx html directory
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose and run
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]