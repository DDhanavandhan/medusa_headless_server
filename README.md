# Medusa Headless Server with AWS ECS Deployment

This project implements a Medusa e-commerce headless server with automated deployment to AWS ECS using GitHub Actions and Terraform.



EXPLANATION VIDEO LINK: https://www.loom.com/share/569a28ecce5c41f5915e99e4b1016622?sid=59dec441-dbb4-48fd-9bdd-f0d48f88b72c



## Project Overview

- **Backend**: Medusa headless e-commerce server
- **Infrastructure**: AWS ECS (Elastic Container Service)
- **IaC**: Terraform for infrastructure management
- **CI/CD**: GitHub Actions for automated deployment
- **Container**: Docker for containerization

## Prerequisites

- Node.js (v16 or later)
- Docker
- AWS CLI configured with appropriate credentials
- Terraform installed
- Git

## Local Development Setup

1. Clone the repository:
```bash
git clone https://github.com/DDhanavandhan/medusa_headless_server.git
cd medusa_headless_server
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.template .env
```
Edit the `.env` file with your configuration:
```env
DATABASE_TYPE=postgres
DATABASE_URL=postgres://user:password@localhost:5432/medusa-db
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret
COOKIE_SECRET=your_cookie_secret
```

4. Start the development server:
```bash
npm run dev
```

## Docker Build

1. Build the Docker image:
```bash
docker build -t medusa-server .
```

2. Run the container locally:
```bash
docker run -p 9000:9000 -e DATABASE_URL=your_db_url -e REDIS_URL=your_redis_url medusa-server
```

## AWS Infrastructure Setup

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed

### Infrastructure Deployment

1. Navigate to the Terraform directory:
```bash
cd terraform
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the infrastructure changes:
```bash
terraform plan
```

4. Apply the infrastructure:
```bash
terraform apply
```

The Terraform configuration will create:
- ECS Cluster
- Task Definition
- Service
- Load Balancer
- VPC and networking components
- Security Groups
- IAM roles and policies

## GitHub Actions Deployment

The project uses GitHub Actions for automated deployment. The workflow is triggered on pushes to the main branch.

### Workflow Steps:
1. Build Docker image
2. Push to Amazon ECR
3. Update ECS service with new image

### Required GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

## Project Structure

```
.
├── src/                    # Source code
│   ├── api/               # API routes
│   ├── services/          # Business logic
│   ├── models/            # Data models
│   └── migrations/        # Database migrations
├── terraform/             # Infrastructure as Code
│   └── main.tf           # Main Terraform configuration
├── .github/
│   └── workflows/        # GitHub Actions workflows
├── Dockerfile            # Docker configuration
└── medusa-config.js      # Medusa configuration
```

## Deployment Process

1. **Local Development**:
   - Make changes to the codebase
   - Test locally using `npm run dev`
   - Commit and push changes

2. **Automated Deployment**:
   - Push to main branch triggers GitHub Actions
   - Workflow builds and pushes Docker image
   - Updates ECS service with new image

3. **Manual Infrastructure Updates**:
   - Make changes to Terraform files
   - Run `terraform plan` to review changes
   - Run `terraform apply` to apply changes

## Monitoring and Maintenance

- Access ECS console to monitor container health
- Check CloudWatch logs for application logs
- Monitor load balancer metrics
- Regular security updates and maintenance

## Troubleshooting

### Common Issues:

1. **Database Connection Issues**:
   - Verify database credentials
   - Check security group rules
   - Ensure database is running

2. **Container Startup Issues**:
   - Check ECS task logs in CloudWatch
   - Verify environment variables
   - Check container resource limits

3. **Deployment Failures**:
   - Check GitHub Actions logs
   - Verify AWS credentials
   - Check ECS service events

## Security Considerations

- All sensitive data stored in AWS Secrets Manager
- Network access controlled via security groups
- HTTPS enabled on load balancer
- Regular security updates
- Proper IAM role configurations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
