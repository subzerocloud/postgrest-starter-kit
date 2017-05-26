# example building using AWS ECR as the remote private registry
# export REMOTE_REPO=<yourawsid>.dkr.ecr.us-east-1.amazonaws.com/openresty
# docker build -t openresty .
# docker tag openresty $REMOTE_REPO:latest
# docker push $REMOTE_REPO:latest


FROM openresty/openresty:jessie

COPY entrypoint.sh /entrypoint.sh
COPY nginx /usr/local/openresty/nginx
COPY lualib /usr/local/openresty/lualib

ENTRYPOINT ["/entrypoint.sh"]