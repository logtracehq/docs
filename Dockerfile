FROM floryn90/hugo:0.161.1-ext-alpine AS builder

USER hugo

WORKDIR /site

COPY --chown=hugo:hugo . .

RUN hugo --minify

FROM node:22-alpine

RUN npm install -g serve

COPY --from=builder /site/public /site/public

EXPOSE 1314

CMD ["serve", "--no-clipboard", "/site/public", "-l", "1314"]
