# Space Beacon

This repository includes the necessary scripts and configurations to deploy a Node.js application onto an Amazon EKS cluster. This setup includes Terraform scripts to create a VPC and an EKS cluster, a Dockerfile to create the Node.js application image, and a Helm chart that deploys the Docker image to the EKS cluster.

## Prerequisites

- AWS CLI installed and configured with appropriate permissions
- Docker installed
- Terraform installed
- Helm installed
- Kubernetes CLI (kubectl) installed
- GitHub account
- AWS account with permissions to manage ECR and EKS
- Docker Hub account (optional)

## Setting up GitHub Actions Workflow

This repository includes a GitHub Actions workflow that automates the building of the Docker image, pushing it to ECR, and deploying the application to the EKS cluster.

The workflow is defined in the `.github/workflows/terraform.yaml` file.

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

## Setup Terraform Cloud

Before you can use Terraform Cloud, you need to sign up for an account at [https://app.terraform.io/signup/account](https://app.terraform.io/signup/account).

Once you have an account, follow these steps to configure AWS credentials:

1. Navigate to your organization's settings page by clicking the "Settings" link at the top of the Terraform Cloud UI.

2. On the left side of the settings page, click on "Variables".

3. In the "Environment Variables" section, click on "Add Variable".

4. Add the following two environment variables:
   
   - `AWS_ACCESS_KEY_ID`: This should be set to your AWS access key.
   - `AWS_SECRET_ACCESS_KEY`: This should be set to your AWS secret access key.

## Build and Deployment Steps

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
## Common Issues and Troubleshooting

### EKS Cluster Creation Issue

When setting up the environment for the first time, you may encounter an issue where the EKS cluster fails to create. This issue may result in error messages and prevent the completion of the setup process.

To resolve this issue, follow these steps:

1. Open the `eks.tf` file in your text editor.

2. Comment out lines 1 to 22. This can typically be done by adding a `#` at the beginning of each line.

3. Run `terraform plan` and `terraform apply` in your terminal. At this point, you may see an error message that `aws-auth` does not exist. This is expected.

4. Go back to the `eks.tf` file and uncomment lines 1 to 22 (remove the `#` at the beginning of each line).

5. Run `terraform plan` and `terraform apply` again.

These steps should resolve the issue and allow the EKS cluster to be created successfully. If you continue to experience problems, please review the error messages and check the [Terraform documentation](https://www.terraform.io/docs/) for further troubleshooting steps.

## Future Recommendations

To enhance the reliability and maintainability of the setup, here are some future improvements to consider:

### Use S3 Bucket for Terraform State

Currently, the Terraform state is managed by terraform cloud remote backend,to be more consistent with whole setup try to store the Terraform state in a S3 bucket.

1. Create an S3 bucket specifically for storing the Terraform state. Make sure that the bucket is properly secured and versioning is enabled.

2. Update the Terraform configuration to use the S3 backend. The bucket name should be specified in the `backend "s3"` block in the `main.tf` file.

3. When running `terraform init`, pass in the bucket name to the `-backend-config` argument. This tells Terraform to use the specified bucket for its state.

By implementing these steps, the Terraform state will be stored in a centralized location accessible to all team members, reducing the risk of inconsistencies.

### Solve EKS Cluster Creation Issue

As mentioned in the [Troubleshooting](#common-issues-and-troubleshooting) section, there's an issue with creating the EKS cluster for the first time. To eliminate this problem, consider updating the Terraform code to handle this scenario more gracefully.

## Contributing

Contributions are welcome! Please read the [contributing guide](CONTRIBUTING.md) to learn about our development process, how to propose bugfixes and improvements, and how to build and test your changes.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
