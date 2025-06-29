# Next.js ECS Deployment

Next.js application deployed on AWS ECS with Terraform and GitHub Actions CI/CD.

## Architecture

<!-- SCHEMA PLACEHOLDER - Insert architecture diagram here -->

## Infrastructure

**AWS Services:**

- **ECS Fargate** - Container orchestration
- **ECR** - Container registry
- **ALB** - Application load balancer
- **VPC** - Isolated network with public/private subnets
- **CloudWatch** - Logging and monitoring
- **IAM** - Roles and permissions

**Infrastructure as Code:**

- **Terraform** - Infrastructure provisioning
- **Modular design** - VPC, ECR, ECS, ALB modules

## Deployment

### Prerequisites

- AWS CLI configured
- Terraform
- Docker
- GitHub account

### Infrastructure Setup

```bash
# Clone repository
git clone <repository-url>
cd nextjs-ecs-deployment

# Configure Terraform variables
cp terraform.example.tfvars terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy infrastructure
terraform init
terraform plan
terraform apply
```

## CI/CD Pipeline

**GitHub Actions Workflow:**

- **Trigger:** Push to `main` branch
- **Build:** Docker image for `linux/amd64`
- **Push:** Image to ECR
- **Deploy:** Update ECS task definition and service
- **Monitor:** Wait for deployment completion

### Setup GitHub Actions

1. Add repository secrets:

   ```
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   ```

2. Push to `main` branch triggers deployment

## Monitoring

**CloudWatch Logs:** `/ecs/my-nextjs-app-service`
**Metrics:** CPU, Memory, Request count via ALB
**Health Checks:** HTTP health endpoint at `/`

## Development

### Local Development

```bash
npm install
npm run dev
# App runs on http://localhost:3000
```

### Docker Testing

```bash
docker build -t my-nextjs-app .
docker run -p 3000:3000 my-nextjs-app
```

## Security

- **Private subnets** for ECS tasks
- **Security groups** restricting traffic flow
- **IAM roles** with least privilege access
- **VPC isolation** from internet
