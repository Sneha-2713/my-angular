### STAGE 1: Build ###    
# We label our stage as 'builder'
FROM node:12.7-alpine as builder

WORKDIR /usr/src/app

COPY . .

RUN npm config set cache ~/.my-yarn-cache-dir

RUN npm install

RUN npm run build

RUN rm -rf .git

### STAGE 2: Setup ###

FROM nginx:1.14.1-alpine

## Copy our default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder 
## to default nginx public folder
COPY --from=builder /usr/src/app/dist/ARH1 /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]