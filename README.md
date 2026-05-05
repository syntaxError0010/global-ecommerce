🚀 Global High-Availability E-commerce Infrastructure
This project simulates a Production-Grade, Multi-Region Cloud Architecture entirely on a local machine using Docker and Terraform. It bypasses traditional cloud sandbox restrictions to demonstrate deep knowledge of networking, high availability, and Infrastructure as Code (IaC).

🎯 Project Objectives
Multi-Region Simulation: Create isolated virtual networks to simulate US-EAST and US-WEST traffic patterns.

High Availability (HA): Deploy multiple container instances per "region" to ensure zero downtime.

Infrastructure as Code: Manage the entire lifecycle of networks and containers using Terraform.

Containerization: Standardize the backend environment using a lightweight Alpine-based Docker image.

🏗️ Architecture Overview
The system is built using a three-tier DevOps approach:

Frontend: A containerized React application served via Nginx.

Regional Backends: Node.js/Express clusters running in isolated Docker bridge networks.

Infrastructure Glue: Terraform scripts that define the virtual VPCs (networks) and scale the services.

📁 File Structure
Plaintext
├── backend/
│   ├── server.js        # Node.js API with Region-awareness
│   ├── Dockerfile       # Optimized Alpine-based image build
│   └── package.json     # Project dependencies
├── terraform/
│   ├── main.tf          # Core IaC defining Networks & Containers
│   └── provider.tf      # Docker provider configuration
└── README.md
🛠️ Tech Stack
Language: Node.js (Backend)

Containerization: Docker

IaC: Terraform

Platform: Localhost (simulating AWS architecture)

🚀 Getting Started
1. Prerequisites
Docker Desktop installed and running.

Terraform CLI installed.

2. Build the Backend Image
Navigate to the root directory and build the regional image:

Bash
docker build -t ecommerce-backend:v1 ./backend
3. Deploy the Infrastructure
Navigate to the Terraform folder and initialize the "Cloud":

Bash
cd terraform
terraform init
terraform apply -auto-approve
4. Verify Global Routing
Once the apply is complete, your local "Cloud" is live. You can check the status of your regional containers:

Bash
docker ps
Visit localhost:[PORT] (defined in your output) to see which container and which "Region" is responding to your request.

👨‍💻 Author
Anupam Regmi

Computer Engineering Student | DevOps & ML Enthusiast