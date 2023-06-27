# Space Beacon

This repository includes the necessary scripts and configurations to deploy a Node.js application onto an Amazon EKS cluster. This setup includes Terraform scripts to create a VPC and an EKS cluster, a Dockerfile to create the Node.js application image, and a Helm chart that deploys the Docker image to the EKS cluster.

## Prerequisites

- AWS CLI installed and configured with appropriate permissions
- Docker installed
- Terraform installed
- Helm installed
- Kubernetes CLI (kubectl) installed
- GitHub account

## Setting up GitHub Actions Workflow

This repository includes a GitHub Actions workflow that automates the building of the Docker image, pushing it to ECR, and deploying the application to the EKS cluster.

The workflow is defined in the `.github/workflows/terraform.yaml` file.

### Prerequisites

- GitHub repository
- AWS account with permissions to manage ECR and EKS
- Docker Hub account (optional)

### Getting Started

1. **Fork and Clone the Repository**

    Fork the repository to your GitHub account and then clone it to your local machine.

    ```bash
    git clone https://github.com/yourusername/repo.git
    cd repo
    ```

2. **Configure AWS Credentials**

   In your GitHub repository, go to 'Settings' -> 'Secrets'. Add the following secrets:

   - `AWS_ACCESS_KEY_ID`: Your AWS access key ID
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
   - `AWS_REGION`: The AWS region where your ECR repository and EKS cluster are located

   These secrets will be used by the GitHub Actions workflow to authenticate with AWS.

3. **Configure Docker Hub Credentials (optional)**

   If your Docker image is being pushed to Docker Hub instead of ECR, you'll also need to configure your Docker Hub username and access token:

   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_TOKEN`: Your Docker Hub access token

4. **Trigger the Workflow**

   The workflow is triggered whenever you push changes to your repository. You can also manually trigger the workflow from the 'Actions' tab in your GitHub repository.

## Getting Started

1. **Build Docker Image**

   The `Dockerfile` in the repository is used to build the Docker image for the Node.js application.

    ```bash
    docker build -t your-image-name .
    ```

2. **Create Infrastructure using Terraform**

   Navigate to the `terraform` directory and initialize Terraform.

    ```bash
    cd terraform
    terraform init
    ```

   Apply the Terraform scripts to create a new VPC and EKS cluster.

    ```bash
    terraform apply
    ```

   After running the above command, Terraform will show the changes to be made. Type `yes` to proceed with the creation of the infrastructure.

3. **Push Docker Image to ECR**

   First, tag your Docker image with the ECR repository URL.

    ```bash
    docker tag your-image-name:latest your-ecr-repository-url:latest
    ```

   Then, push the Docker image to your ECR repository.

    ```bash
    docker push your-ecr-repository-url:latest
    ```

4. **Deploy Application using Helm**

   Navigate to the `helm` directory.

    ```bash
    cd ../helm
    ```

   Install the Helm chart to deploy the application onto your EKS cluster.

    ```bash
    helm install your-chart-name .
    ```

## Contributing

Contributions are welcome! Please read the [contributing guide](CONTRIBUTING.md) to learn about our development process, how to propose bugfixes and improvements, and how to build and test your changes.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
