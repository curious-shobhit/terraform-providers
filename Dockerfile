FROM alpine:latest

# Install required dependencies
RUN apk update && apk add --no-cache curl unzip

# Set the Terraform version
ENV TERRAFORM_VERSION=0.15.5

# Download and install Terraform
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Set the working directory
WORKDIR /app
COPY config.tf /app/config.tf
RUN terraform init
RUN mkdir "$HOME/tf_cache"
RUN echo 'provider_installation {' >> .terraformrc && \
    echo '  filesystem_mirror {' >> .terraformrc && \
    echo '    path    = "'"$HOME"'/tf_cache" # "c:/tf_cache"' >> .terraformrc && \
    echo '    include = ["registry.terraform.io/hashicorp/*"]' >> .terraformrc && \
    echo '  }' >> .terraformrc && \
    echo '  direct {' >> .terraformrc && \
    echo '    exclude = ["registry.terraform.io/hashicorp/*"]' >> .terraformrc && \
    echo '  }' >> .terraformrc && \
    echo '}' >> .terraformrc && \
    echo '' >> .terraformrc && \
    echo 'plugin_cache_dir = "'"$HOME"'/tf_cache" # "c:/tf_cache"' >> .terraformrc && \
    echo 'disable_checkpoint = true' >> .terraformrc
RUN mv .terraformrc "/app/.terraformrc"
# Set environment variables
RUN mv /app/.terraform/providers/registry.terraform.io /root/tf_cache
ENV TF_CLI_CONFIG_FILE="/app/.terraformrc"
ENV TF_PLUGIN_CACHE_DIR="/root/tf_cache"
RUN rm -rf .terraform .terraform.lock.hcl


# Set the entrypoint to an empty command
ENTRYPOINT [""]
