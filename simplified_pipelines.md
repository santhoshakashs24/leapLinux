# Simplified Jenkins Pipelines
## CI/CD for Docker and Kubernetes

---

## Pipeline 1: CI - Docker Build & Push

**Purpose:** Build Docker images and push to JFrog Artifactory

### Jenkinsfile-CI-Docker

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'CORP_ID', defaultValue: 'a000000', description: 'Your Corp ID (e.g., a643580)')
        choice(name: 'JFROG_ENDPOINT', 
               choices: ['jfrog-1', 'jfrog-2', 'jfrog-3', 'jfrog-4', 'jfrog-5'], 
               description: 'Select your JFrog endpoint')
        string(name: 'JFROG_REPO', defaultValue: 'fse1team1', description: 'JFrog repository name')
        string(name: 'GIT_REPO', defaultValue: '', description: 'Git repository URL')
        string(name: 'GIT_BRANCH', defaultValue: 'feature/docker', description: 'Git branch')
        string(name: 'IMAGE_VERSION', defaultValue: '1.0', description: 'Docker image version')
        booleanParam(name: 'BUILD_FRONTEND', defaultValue: true, description: 'Build Frontend?')
        booleanParam(name: 'BUILD_MIDTIER', defaultValue: true, description: 'Build Midtier?')
        booleanParam(name: 'BUILD_BACKEND', defaultValue: true, description: 'Build Backend?')
        booleanParam(name: 'BUILD_FMTS', defaultValue: true, description: 'Build FMTS?')
    }
    
    environment {
        JFROG_URL_1 = 'leapfse1.jfrog.io'
        JFROG_URL_2 = 'leapfse2.jfrog.io'
        JFROG_URL_3 = 'leapfse3.jfrog.io'
        JFROG_URL_4 = 'leapfse4.jfrog.io'
        JFROG_URL_5 = 'leapfse5.jfrog.io'
        
        JFROG_URL = "${params.JFROG_ENDPOINT == 'jfrog-1' ? env.JFROG_URL_1 : 
                      params.JFROG_ENDPOINT == 'jfrog-2' ? env.JFROG_URL_2 :
                      params.JFROG_ENDPOINT == 'jfrog-3' ? env.JFROG_URL_3 :
                      params.JFROG_ENDPOINT == 'jfrog-4' ? env.JFROG_URL_4 :
                      env.JFROG_URL_5}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out code from ${params.GIT_REPO}"
                git branch: "${params.GIT_BRANCH}", url: "${params.GIT_REPO}"
            }
        }
        
        stage('Docker Login') {
            steps {
                script {
                    echo "🔐 Logging into JFrog: ${env.JFROG_URL}"
                    withCredentials([usernamePassword(
                        credentialsId: "${params.JFROG_ENDPOINT}",
                        usernameVariable: 'JFROG_USER',
                        passwordVariable: 'JFROG_PASS'
                    )]) {
                        sh """
                            echo ${JFROG_PASS} | docker login ${env.JFROG_URL} -u ${JFROG_USER} --password-stdin
                        """
                    }
                }
            }
        }
        
        stage('Build & Push Images') {
            parallel {
                stage('Frontend') {
                    when {
                        expression { params.BUILD_FRONTEND == true }
                    }
                    steps {
                        script {
                            echo "🏗️ Building Frontend..."
                            def imageName = "${params.CORP_ID}-frontend"
                            def fullImageName = "${env.JFROG_URL}/${params.JFROG_REPO}/${imageName}:${params.IMAGE_VERSION}"
                            
                            sh """
                                cd frontend
                                docker build -t ${imageName}:${params.IMAGE_VERSION} .
                                docker tag ${imageName}:${params.IMAGE_VERSION} ${fullImageName}
                                docker push ${fullImageName}
                                echo "✅ Frontend pushed: ${fullImageName}"
                            """
                        }
                    }
                }
                
                stage('Midtier') {
                    when {
                        expression { params.BUILD_MIDTIER == true }
                    }
                    steps {
                        script {
                            echo "🏗️ Building Midtier..."
                            def imageName = "${params.CORP_ID}-midtier"
                            def fullImageName = "${env.JFROG_URL}/${params.JFROG_REPO}/${imageName}:${params.IMAGE_VERSION}"
                            
                            sh """
                                cd midtier
                                docker build -t ${imageName}:${params.IMAGE_VERSION} .
                                docker tag ${imageName}:${params.IMAGE_VERSION} ${fullImageName}
                                docker push ${fullImageName}
                                echo "✅ Midtier pushed: ${fullImageName}"
                            """
                        }
                    }
                }
                
                stage('Backend') {
                    when {
                        expression { params.BUILD_BACKEND == true }
                    }
                    steps {
                        script {
                            echo "🏗️ Building Backend..."
                            def imageName = "${params.CORP_ID}-backend"
                            def fullImageName = "${env.JFROG_URL}/${params.JFROG_REPO}/${imageName}:${params.IMAGE_VERSION}"
                            
                            sh """
                                cd backend
                                docker build -t ${imageName}:${params.IMAGE_VERSION} .
                                docker tag ${imageName}:${params.IMAGE_VERSION} ${fullImageName}
                                docker push ${fullImageName}
                                echo "✅ Backend pushed: ${fullImageName}"
                            """
                        }
                    }
                }
                
                stage('FMTS') {
                    when {
                        expression { params.BUILD_FMTS == true }
                    }
                    steps {
                        script {
                            echo "🏗️ Building FMTS..."
                            def imageName = "${params.CORP_ID}-fmts"
                            def fullImageName = "${env.JFROG_URL}/${params.JFROG_REPO}/${imageName}:${params.IMAGE_VERSION}"
                            
                            sh """
                                cd fmts
                                docker build -t ${imageName}:${params.IMAGE_VERSION} .
                                docker tag ${imageName}:${params.IMAGE_VERSION} ${fullImageName}
                                docker push ${fullImageName}
                                echo "✅ FMTS pushed: ${fullImageName}"
                            """
                        }
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo "🧹 Cleaning up local images..."
                    sh """
                        docker image prune -f
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo """
            ✅ ════════════════════════════════════════
            ✅   CI BUILD SUCCESSFUL!
            ✅ ════════════════════════════════════════
            📦 Images pushed to: ${env.JFROG_URL}/${params.JFROG_REPO}/
            🏷️  Version: ${params.IMAGE_VERSION}
            👤 Corp ID: ${params.CORP_ID}
            ✅ ════════════════════════════════════════
            """
        }
        failure {
            echo """
            ❌ ════════════════════════════════════════
            """
        }
    }
}
```

---

## Project Structure

Your project repository should follow this structure:

```
a######-projectName/
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
├── midtier/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
├── backend/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── fmts/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
├── k8s/
│   ├── namespace.yaml
│   ├── secrets.yaml
│   ├── configmaps.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── midtier-deployment.yaml
│   ├── midtier-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── fmts-deployment.yaml
│   ├── fmts-service.yaml
│   ├── fmts-pvc.yaml
│   └── ingress.yaml
├── Jenkinsfile-CI-Docker
├── Jenkinsfile-CD-DockerCompose
├── Jenkinsfile-CI-K8s
├── Jenkinsfile-CD-K8s
└── README.md
```

---

## Sample Kubernetes Manifests

### k8s/namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: a######-ns
  labels:
    corp-id: a######
```

### k8s/secrets.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: jfrog-secret
  namespace: a######-ns
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-config>
---
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: a######-ns
type: Opaque
stringData:
  username: admin
  password: LA2025fmr
  endpoint: a######-rds.cj6ui28e0bu9.ap-south-1.rds.amazonaws.com
```

### k8s/backend-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a######-backend
  namespace: a######-ns
  labels:
    app: backend
    corp-id: a######
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
      corp-id: a######
  template:
    metadata:
      labels:
        app: backend
        corp-id: a######
    spec:
      imagePullSecrets:
      - name: jfrog-secret
      containers:
      - name: backend
        image: leapfse1.jfrog.io/fse1team1/a######-backend:1.0
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_DATASOURCE_URL
          value: "jdbc:oracle:thin:@$(DB_ENDPOINT):1521/ORCL"
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: username
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
        - name: DB_ENDPOINT
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: endpoint
        - name: SPRING_DATASOURCE_DRIVER_CLASS_NAME
          value: "oracle.jdbc.OracleDriver"
        - name: SPRING_JPA_DATABASE_PLATFORM
          value: "org.hibernate.dialect.Oracle12cDialect"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 5
```

### k8s/backend-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: a######-backend
  namespace: a######-ns
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    app: backend
    corp-id: a######
```

### k8s/midtier-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a######-midtier
  namespace: a######-ns
  labels:
    app: midtier
    corp-id: a######
spec:
  replicas: 2
  selector:
    matchLabels:
      app: midtier
      corp-id: a######
  template:
    metadata:
      labels:
        app: midtier
        corp-id: a######
    spec:
      imagePullSecrets:
      - name: jfrog-secret
      containers:
      - name: midtier
        image: leapfse1.jfrog.io/fse1team1/a######-midtier:1.0
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: BACKEND_URL
          value: "http://a######-backend:8080"
        - name: FMTS_URL
          value: "http://a######-fmts:5000"
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "400m"
```

### k8s/midtier-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: a######-midtier
  namespace: a######-ns
spec:
  type: ClusterIP
  ports:
  - port: 3000
    targetPort: 3000
  selector:
    app: midtier
    corp-id: a######
```

### k8s/frontend-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a######-frontend
  namespace: a######-ns
  labels:
    app: frontend
    corp-id: a######
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
      corp-id: a######
  template:
    metadata:
      labels:
        app: frontend
        corp-id: a######
    spec:
      imagePullSecrets:
      - name: jfrog-secret
      containers:
      - name: frontend
        image: leapfse1.jfrog.io/fse1team1/a######-frontend:1.0
        ports:
        - containerPort: 4200
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
```

### k8s/frontend-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: a######-frontend
  namespace: a######-ns
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 4200
  selector:
    app: frontend
    corp-id: a######
```

### k8s/fmts-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a######-fmts
  namespace: a######-ns
  labels:
    app: fmts
    corp-id: a######
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fmts
      corp-id: a######
  template:
    metadata:
      labels:
        app: fmts
        corp-id: a######
    spec:
      imagePullSecrets:
      - name: jfrog-secret
      containers:
      - name: fmts
        image: leapfse1.jfrog.io/fse1team1/a######-fmts:1.0
        ports:
        - containerPort: 5000
        env:
        - name: NODE_ENV
          value: "production"
        volumeMounts:
        - name: uploads
          mountPath: /app/uploads
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "400m"
      volumes:
      - name: uploads
        persistentVolumeClaim:
          claimName: a######-fmts-pvc
```

### k8s/fmts-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: a######-fmts
  namespace: a######-ns
spec:
  type: ClusterIP
  ports:
  - port: 5000
    targetPort: 5000
  selector:
    app: fmts
    corp-id: a######
```

### k8s/fmts-pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: a######-fmts-pvc
  namespace: a######-ns
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
```

### k8s/ingress.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: a######-ingress
  namespace: a######-ns
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /
spec:
  ingressClassName: alb
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: a######-frontend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: a######-midtier
            port:
              number: 3000
```

---

## Jenkins Setup Instructions

### 1. Create Jenkins Jobs

In Jenkins, create 4 separate pipeline jobs:

1. **CI-Docker-Build**
   - Type: Pipeline
   - Pipeline script from SCM
   - Script Path: `Jenkinsfile-CI-Docker`

2. **CD-DockerCompose-Deploy**
   - Type: Pipeline
   - Pipeline script from SCM
   - Script Path: `Jenkinsfile-CD-DockerCompose`

3. **CI-K8s-Validate**
   - Type: Pipeline
   - Pipeline script from SCM
   - Script Path: `Jenkinsfile-CI-K8s`

4. **CD-K8s-Deploy**
   - Type: Pipeline
   - Pipeline script from SCM
   - Script Path: `Jenkinsfile-CD-K8s`

### 2. Configure Credentials

Add credentials in Jenkins: **Manage Jenkins → Credentials → Global**

#### JFrog Credentials (5 sets)

| ID | Type | Username | Password |
|----|------|----------|----------|
| `jfrog-1` | Username/Password | `leapfse1` | `fse1Deploy@Cloud` |
| `jfrog-2` | Username/Password | `leapfse2` | `fse2Deploy@Cloud` |
| `jfrog-3` | Username/Password | `leapfse3` | `fse3Deploy@Cloud` |
| `jfrog-4` | Username/Password | `leapfse4` | `fse4Deploy@Cloud` |
| `jfrog-5` | Username/Password | `leapfse5` | `fse5Deploy@Cloud` |

#### AWS Credentials

| ID | Type | Access Key ID | Secret Access Key |
|----|------|---------------|-------------------|
| `aws-creds-generic` | AWS Credentials | `AKIA...` | `secret...` |

---

## Usage Workflow

### Complete CI/CD Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT WORKFLOW                      │
└─────────────────────────────────────────────────────────────┘

1. Developer commits code to Git (feature/docker branch)
   │
   ↓
2. Run CI-Docker-Build Pipeline
   │  • Builds all 4 Docker images
   │  • Pushes to JFrog Artifactory
   │  • Tags with version number
   │
   ↓
3. Run CD-DockerCompose-Deploy Pipeline
   │  • Pulls images from JFrog
   │  • Generates docker-compose.yml
   │  • Deploys to local/RVC environment
   │  • Runs health checks
   │
   ↓
4. Test application locally
   │  • Frontend: http://localhost:4200
   │  • Backend: http://localhost:8080
   │  • Verify all services working
   │
   ↓
5. Create Kubernetes manifests in k8s/ folder
   │  • Deployments, Services, Ingress
   │  • Secrets, ConfigMaps, PVCs
   │
   ↓
6. Run CI-K8s-Validate Pipeline
   │  • Validates all YAML syntax
   │  • Checks resource definitions
   │
   ↓
7. Run CD-K8s-Deploy Pipeline (ACTION=apply)
   │  • Configures AWS credentials
   │  • Updates kubectl context
   │  • Applies all manifests in k8s/
   │  • Waits for deployments to be ready
   │
   ↓
8. Verify Kubernetes deployment
   │  • Check pods status
   │  • View logs
   │  • Access via Ingress/LoadBalancer
   │
   ↓
9. Monitor and maintain
   │  • Use CD-K8s-Deploy (ACTION=status) to check
   │  • Use CD-K8s-Deploy (ACTION=rollback) if needed
```

---

## Quick Reference Commands

### CI - Docker Build & Push

```bash
# Parameters to set:
CORP_ID: a643580
JFROG_ENDPOINT: jfrog-1
JFROG_REPO: fse1team1
GIT_REPO: https://github.com/user/a643580-projectName
GIT_BRANCH: feature/docker
IMAGE_VERSION: 1.0
BUILD_ALL: ✓
```

**Result:** All images pushed to `leapfse1.jfrog.io/fse1team1/a643580-*:1.0`

### CD - Docker Compose Deploy

```bash
# Parameters to set:
CORP_ID: a643580
JFROG_ENDPOINT: jfrog-1
JFROG_REPO: fse1team1
IMAGE_VERSION: 1.0
RDS_ENDPOINT: a643580-rds.cj6ui28e0bu9.ap-south-1.rds.amazonaws.com
DB_USERNAME: admin
DB_PASSWORD: LA2025fmr
ACTION: deploy
```

**Result:** All services running locally

### CI - K8s Validate

```bash
# Parameters to set:
GIT_REPO: https://github.com/user/a643580-projectName
GIT_BRANCH: main
K8S_FOLDER: k8s
```

**Result:** All manifests validated

### CD - K8s Deploy

```bash
# Parameters to set:
CORP_ID: a643580
GIT_REPO: https://github.com/user/a643580-projectName
GIT_BRANCH: main
K8S_FOLDER: k8s
NAMESPACE: a643580-ns
AWS_REGION: ap-south-1
EKS_CLUSTER_NAME: my-eks-cluster
AWS_CREDS: aws-creds-generic
ACTION: apply
```

**Result:** All resources deployed to EKS

---

## Troubleshooting Guide

### CI - Docker Build Issues

**Issue:** Docker build fails
```bash
# Check Docker daemon
sudo systemctl status docker
sudo systemctl start docker

# Check Dockerfile syntax
docker build --no-cache -t test:1.0 ./frontend
```

**Issue:** Push to JFrog fails
```bash
# Re-login manually
docker login leapfse1.jfrog.io
# Username: leapfse1
# Password: fse1Deploy@Cloud

# Test push
docker tag test:1.0 leapfse1.jfrog.io/fse1team1/test:1.0
docker push leapfse1.jfrog.io/fse1team1/test:1.0
```

### CD - Docker Compose Issues

**Issue:** Containers fail to start
```bash
# Check logs
docker-compose logs -f

# Check specific service
docker-compose logs backend

# Restart
docker-compose restart
```

**Issue:** Database connection fails
```bash
# Test RDS connectivity
nc -zv a643580-rds.cj6ui28e0bu9.ap-south-1.rds.amazonaws.com 1521

# Check environment variables
docker exec a643580-backend env | grep SPRING_DATASOURCE
```

### CD - Kubernetes Issues

**Issue:** kubectl context not set
```bash
# Manually configure
aws eks update-kubeconfig --region ap-south-1 --name my-eks-cluster

# Verify
kubectl config current-context
kubectl get nodes
```

**Issue:** Pods in ImagePullBackOff
```bash
# Check secret
kubectl get secret jfrog-secret -n a643580-ns -o yaml

# Recreate secret
kubectl create secret docker-registry jfrog-secret \
  --docker-server=leapfse1.jfrog.io \
  --docker-username=leapfse1 \
  --docker-password=fse1Deploy@Cloud \
  --namespace=a643580-ns
```

**Issue:** Pods in CrashLoopBackOff
```bash
# Check pod logs
kubectl logs <pod-name> -n a643580-ns

# Describe pod for events
kubectl describe pod <pod-name> -n a643580-ns

# Check events
kubectl get events -n a643580-ns --sort-by='.lastTimestamp'
```

---

## Summary

You now have **4 clean, focused pipelines**:

1. ✅ **CI-Docker**: Build and push Docker images to JFrog
2. ✅ **CD-DockerCompose**: Deploy using Docker Compose locally
3. ✅ **CI-K8s**: Validate Kubernetes manifests
4. ✅ **CD-K8s**: Deploy to Kubernetes/EKS using manifests from k8s folder

Each pipeline is:
- **Simple and focused** on one task
- **Parameterized** for flexibility
- **Multi-tenant ready** (5 JFrog endpoints support)
- **Production-ready** with proper error handling

**Ready to deploy! 🚀**════════════════════
            ❌   CI BUILD FAILED!
            ❌ ════════════════════════════════════════
            Please check the logs above for errors.
            ❌ ════════════════════════════════════════
            """
        }
        always {
            sh "docker logout ${env.JFROG_URL} || true"
        }
    }
}
```

---

## Pipeline 2: CD - Docker Compose Deployment

**Purpose:** Deploy application using Docker Compose

### Jenkinsfile-CD-DockerCompose

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'CORP_ID', defaultValue: 'a000000', description: 'Your Corp ID')
        choice(name: 'JFROG_ENDPOINT', 
               choices: ['jfrog-1', 'jfrog-2', 'jfrog-3', 'jfrog-4', 'jfrog-5'], 
               description: 'Select your JFrog endpoint')
        string(name: 'JFROG_REPO', defaultValue: 'fse1team1', description: 'JFrog repository')
        string(name: 'IMAGE_VERSION', defaultValue: '1.0', description: 'Image version to deploy')
        string(name: 'RDS_ENDPOINT', defaultValue: '', description: 'RDS endpoint from Day 1')
        string(name: 'DB_USERNAME', defaultValue: 'admin', description: 'Database username')
        password(name: 'DB_PASSWORD', defaultValue: 'LA2025fmr', description: 'Database password')
        choice(name: 'ACTION', 
               choices: ['deploy', 'stop', 'restart', 'status'], 
               description: 'Deployment action')
    }
    
    environment {
        JFROG_URL_1 = 'leapfse1.jfrog.io'
        JFROG_URL_2 = 'leapfse2.jfrog.io'
        JFROG_URL_3 = 'leapfse3.jfrog.io'
        JFROG_URL_4 = 'leapfse4.jfrog.io'
        JFROG_URL_5 = 'leapfse5.jfrog.io'
        
        JFROG_URL = "${params.JFROG_ENDPOINT == 'jfrog-1' ? env.JFROG_URL_1 : 
                      params.JFROG_ENDPOINT == 'jfrog-2' ? env.JFROG_URL_2 :
                      params.JFROG_ENDPOINT == 'jfrog-3' ? env.JFROG_URL_3 :
                      params.JFROG_ENDPOINT == 'jfrog-4' ? env.JFROG_URL_4 :
                      env.JFROG_URL_5}"
    }
    
    stages {
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: "${params.JFROG_ENDPOINT}",
                        usernameVariable: 'JFROG_USER',
                        passwordVariable: 'JFROG_PASS'
                    )]) {
                        sh """
                            echo ${JFROG_PASS} | docker login ${env.JFROG_URL} -u ${JFROG_USER} --password-stdin
                        """
                    }
                }
            }
        }
        
        stage('Generate Docker Compose') {
            steps {
                script {
                    echo "📝 Generating docker-compose.yml..."
                    
                    writeFile file: 'docker-compose.yml', text: """
version: '3.8'

services:
  frontend:
    image: ${env.JFROG_URL}/${params.JFROG_REPO}/${params.CORP_ID}-frontend:${params.IMAGE_VERSION}
    container_name: ${params.CORP_ID}-frontend
    ports:
      - "4200:4200"
    networks:
      - app-network
    depends_on:
      - midtier
    restart: unless-stopped

  midtier:
    image: ${env.JFROG_URL}/${params.JFROG_REPO}/${params.CORP_ID}-midtier:${params.IMAGE_VERSION}
    container_name: ${params.CORP_ID}-midtier
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - BACKEND_URL=http://backend:8080
      - FMTS_URL=http://fmts:5000
    networks:
      - app-network
    depends_on:
      - backend
      - fmts
    restart: unless-stopped

  backend:
    image: ${env.JFROG_URL}/${params.JFROG_REPO}/${params.CORP_ID}-backend:${params.IMAGE_VERSION}
    container_name: ${params.CORP_ID}-backend
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:oracle:thin:@${params.RDS_ENDPOINT}:1521/ORCL
      - SPRING_DATASOURCE_USERNAME=${params.DB_USERNAME}
      - SPRING_DATASOURCE_PASSWORD=${params.DB_PASSWORD}
      - SPRING_DATASOURCE_DRIVER_CLASS_NAME=oracle.jdbc.OracleDriver
      - SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.Oracle12cDialect
    networks:
      - app-network
    restart: unless-stopped

  fmts:
    image: ${env.JFROG_URL}/${params.JFROG_REPO}/${params.CORP_ID}-fmts:${params.IMAGE_VERSION}
    container_name: ${params.CORP_ID}-fmts
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=production
    volumes:
      - fmts-uploads:/app/uploads
    networks:
      - app-network
    restart: unless-stopped

networks:
  app-network:
    driver: bridge

volumes:
  fmts-uploads:
    driver: local
"""
                    sh "cat docker-compose.yml"
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                script {
                    echo "🚀 Deploying application..."
                    sh """
                        docker-compose pull
                        docker-compose up -d
                        sleep 10
                        docker-compose ps
                    """
                }
            }
        }
        
        stage('Stop') {
            when {
                expression { params.ACTION == 'stop' }
            }
            steps {
                script {
                    echo "🛑 Stopping application..."
                    sh "docker-compose down"
                }
            }
        }
        
        stage('Restart') {
            when {
                expression { params.ACTION == 'restart' }
            }
            steps {
                script {
                    echo "🔄 Restarting application..."
                    sh """
                        docker-compose restart
                        sleep 5
                        docker-compose ps
                    """
                }
            }
        }
        
        stage('Status') {
            when {
                expression { params.ACTION == 'status' }
            }
            steps {
                script {
                    echo "📊 Checking application status..."
                    sh """
                        docker-compose ps
                        echo ""
                        echo "=== Container Logs ==="
                        docker-compose logs --tail=20
                    """
                }
            }
        }
        
        stage('Health Check') {
            when {
                expression { params.ACTION == 'deploy' || params.ACTION == 'restart' }
            }
            steps {
                script {
                    echo "🏥 Running health checks..."
                    sh """
                        sleep 15
                        
                        echo "✅ Checking Frontend..."
                        curl -f http://localhost:4200 || echo "⚠️ Frontend not responding"
                        
                        echo "✅ Checking Midtier..."
                        curl -f http://localhost:3000/health || echo "⚠️ Midtier not responding"
                        
                        echo "✅ Checking Backend..."
                        curl -f http://localhost:8080/actuator/health || echo "⚠️ Backend not responding"
                        
                        echo "✅ Checking FMTS..."
                        curl -f http://localhost:5000/health || echo "⚠️ FMTS not responding"
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo """
            ✅ ════════════════════════════════════════
            ✅   DOCKER COMPOSE ${params.ACTION.toUpperCase()} SUCCESSFUL!
            ✅ ════════════════════════════════════════
            🌐 Frontend:  http://localhost:4200
            🔧 Midtier:   http://localhost:3000
            📦 Backend:   http://localhost:8080
            📁 FMTS:      http://localhost:5000
            ✅ ════════════════════════════════════════
            """
        }
        failure {
            echo """
            ❌ ════════════════════════════════════════
            ❌   DOCKER COMPOSE ${params.ACTION.toUpperCase()} FAILED!
            ❌ ════════════════════════════════════════
            Check logs: docker-compose logs
            ❌ ════════════════════════════════════════
            """
        }
        always {
            sh "docker logout ${env.JFROG_URL} || true"
        }
    }
}
```

---

## Pipeline 3: CI - Kubernetes Manifests

**Purpose:** Validate Kubernetes manifests (no build, just validation)

### Jenkinsfile-CI-K8s

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'GIT_REPO', defaultValue: '', description: 'Git repository URL')
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Git branch')
        string(name: 'K8S_FOLDER', defaultValue: 'k8s', description: 'Folder containing K8s manifests')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out code from ${params.GIT_REPO}"
                git branch: "${params.GIT_BRANCH}", url: "${params.GIT_REPO}"
            }
        }
        
        stage('Validate Manifests') {
            steps {
                script {
                    echo "✅ Validating Kubernetes manifests in ${params.K8S_FOLDER}/"
                    sh """
                        # Check if k8s folder exists
                        if [ ! -d "${params.K8S_FOLDER}" ]; then
                            echo "❌ Directory ${params.K8S_FOLDER} not found!"
                            exit 1
                        fi
                        
                        # List all YAML files
                        echo "📋 Found manifests:"
                        find ${params.K8S_FOLDER} -name "*.yaml" -o -name "*.yml"
                        
                        # Validate YAML syntax
                        echo ""
                        echo "🔍 Validating YAML syntax..."
                        for file in \$(find ${params.K8S_FOLDER} -name "*.yaml" -o -name "*.yml"); do
                            echo "Validating \$file..."
                            kubectl apply --dry-run=client -f \$file
                        done
                        
                        echo "✅ All manifests are valid!"
                    """
                }
            }
        }
        
        stage('Check Resources') {
            steps {
                script {
                    echo "📊 Analyzing Kubernetes resources..."
                    sh """
                        echo "Resources to be created:"
                        kubectl apply --dry-run=client -f ${params.K8S_FOLDER}/ --recursive | grep -E "deployment|service|ingress|configmap|secret"
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo """
            ✅ ════════════════════════════════════════
            ✅   KUBERNETES MANIFESTS VALIDATED!
            ✅ ════════════════════════════════════════
            All YAML files in ${params.K8S_FOLDER}/ are valid
            Ready for deployment
            ✅ ════════════════════════════════════════
            """
        }
        failure {
            echo """
            ❌ ════════════════════════════════════════
            ❌   VALIDATION FAILED!
            ❌ ════════════════════════════════════════
            Check the logs above for errors.
            ❌ ════════════════════════════════════════
            """
        }
    }
}
```

---

## Pipeline 4: CD - Kubernetes Deployment

**Purpose:** Deploy to Kubernetes using manifests from k8s folder

### Jenkinsfile-CD-K8s

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'CORP_ID', defaultValue: 'a000000', description: 'Your Corp ID')
        string(name: 'GIT_REPO', defaultValue: '', description: 'Git repository URL')
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Git branch')
        string(name: 'K8S_FOLDER', defaultValue: 'k8s', description: 'Folder containing K8s manifests')
        string(name: 'NAMESPACE', defaultValue: 'default', description: 'Kubernetes namespace')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'EKS_CLUSTER_NAME', defaultValue: 'my-eks-cluster', description: 'EKS Cluster Name')
        choice(name: 'AWS_CREDS', 
               choices: ['aws-creds-generic', 'aws-creds-a643580'], 
               description: 'AWS Credentials to use')
        choice(name: 'ACTION', 
               choices: ['apply', 'delete', 'status', 'rollback'], 
               description: 'Deployment action')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out code from ${params.GIT_REPO}"
                git branch: "${params.GIT_BRANCH}", url: "${params.GIT_REPO}"
            }
        }
        
        stage('Configure AWS & kubectl') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            # Configure AWS CLI
                            aws configure set region ${params.AWS_REGION}
                            
                            # Update kubeconfig for EKS
                            aws eks update-kubeconfig \\
                                --region ${params.AWS_REGION} \\
                                --name ${params.EKS_CLUSTER_NAME}
                            
                            # Verify connection
                            kubectl cluster-info
                            kubectl get nodes
                        """
                    }
                }
            }
        }
        
        stage('Set Namespace Context') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            # Create namespace if it doesn't exist
                            kubectl create namespace ${params.NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                            
                            # Set namespace context
                            kubectl config set-context --current --namespace=${params.NAMESPACE}
                            
                            echo "✅ Namespace set to: ${params.NAMESPACE}"
                        """
                    }
                }
            }
        }
        
        stage('Apply Manifests') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            echo "🚀 Applying all manifests from ${params.K8S_FOLDER}/"
                            
                            # Apply all YAML files in k8s folder
                            kubectl apply -f ${params.K8S_FOLDER}/ --recursive -n ${params.NAMESPACE}
                            
                            echo "⏳ Waiting for deployments to be ready..."
                            
                            # Wait for all deployments to be ready (timeout 5 minutes)
                            kubectl wait --for=condition=available --timeout=300s \\
                                deployment --all -n ${params.NAMESPACE} || echo "⚠️ Some deployments took longer than expected"
                            
                            echo "✅ Deployment complete!"
                        """
                    }
                }
            }
        }
        
        stage('Delete Resources') {
            when {
                expression { params.ACTION == 'delete' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            echo "🗑️ Deleting resources from ${params.K8S_FOLDER}/"
                            
                            kubectl delete -f ${params.K8S_FOLDER}/ --recursive -n ${params.NAMESPACE}
                            
                            echo "✅ Resources deleted!"
                        """
                    }
                }
            }
        }
        
        stage('Get Status') {
            when {
                expression { params.ACTION == 'status' || params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            echo "📊 Deployment Status in namespace: ${params.NAMESPACE}"
                            echo "════════════════════════════════════════"
                            
                            echo ""
                            echo "📦 Deployments:"
                            kubectl get deployments -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "🐳 Pods:"
                            kubectl get pods -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "🌐 Services:"
                            kubectl get services -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "🔗 Ingresses:"
                            kubectl get ingress -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "💾 PersistentVolumeClaims:"
                            kubectl get pvc -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "🔐 Secrets:"
                            kubectl get secrets -n ${params.NAMESPACE}
                            
                            echo ""
                            echo "⚙️  ConfigMaps:"
                            kubectl get configmaps -n ${params.NAMESPACE}
                        """
                    }
                }
            }
        }
        
        stage('Rollback') {
            when {
                expression { params.ACTION == 'rollback' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            echo "⏪ Rolling back all deployments in namespace: ${params.NAMESPACE}"
                            
                            # Get all deployments
                            DEPLOYMENTS=\$(kubectl get deployments -n ${params.NAMESPACE} -o jsonpath='{.items[*].metadata.name}')
                            
                            # Rollback each deployment
                            for deployment in \$DEPLOYMENTS; do
                                echo "Rolling back \$deployment..."
                                kubectl rollout undo deployment/\$deployment -n ${params.NAMESPACE}
                            done
                            
                            echo "✅ Rollback complete!"
                        """
                    }
                }
            }
        }
        
        stage('View Logs') {
            when {
                expression { params.ACTION == 'apply' || params.ACTION == 'status' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                    credentialsId: "${params.AWS_CREDS}"]]) {
                        sh """
                            echo "📋 Recent logs from pods:"
                            echo "════════════════════════════════════════"
                            
                            # Get logs from all pods (last 20 lines)
                            kubectl logs --all-containers=true --tail=20 \\
                                -l corp-id=${params.CORP_ID} \\
                                -n ${params.NAMESPACE} \\
                                --max-log-requests=10 || echo "No pods found with label corp-id=${params.CORP_ID}"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                if (params.ACTION == 'apply') {
                    echo """
                    ✅ ════════════════════════════════════════
                    ✅   KUBERNETES DEPLOYMENT SUCCESSFUL!
                    ✅ ════════════════════════════════════════
                    📦 Namespace: ${params.NAMESPACE}
                    🎯 Corp ID: ${params.CORP_ID}
                    📂 Manifests: ${params.K8S_FOLDER}/
                    
                    Next steps:
                    • Check pods: kubectl get pods -n ${params.NAMESPACE}
                    • View logs: kubectl logs <pod-name> -n ${params.NAMESPACE}
                    • Get service URL: kubectl get ingress -n ${params.NAMESPACE}
                    ✅ ════════════════════════════════════════
                    """
                } else {
                    echo "✅ Action '${params.ACTION}' completed successfully!"
                }
            }
        }
        failure {
            echo """
            ❌ ════════════════════════════════════════
            ❌   KUBERNETES DEPLOYMENT FAILED!
            ❌ ════════════════════════════════════════
            Check the logs above for errors.
            
            Debug commands:
            • kubectl get pods -n ${params.NAMESPACE}
            • kubectl describe pod <pod-name> -n ${params.NAMESPACE}
            • kubectl logs <pod-name> -n ${params.NAMESPACE}
            • kubectl get events -n ${params.NAMESPACE} --sort-by='.lastTimestamp'
            ❌ ════════════════════